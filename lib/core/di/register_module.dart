import 'dart:io';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:parkir_digital_bapenda/core/network/connectivity_check_interceptor.dart';
import '../network/dio_auth_interceptor.dart';
import '../network/env_config.dart';
import '../network/resilent_dns_resolver.dart';
import '../utils/app_logger.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio provideDio(DioAuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        // 🚀 FIX: connectTimeout 30s -> 25s. Angka ini WAJIB ≥ total budget
        // internal connectionFactory di bawah (DNS 8s + TCP connect 8s +
        // TLS 8s = 24s worst-case), supaya outer timeout ini tidak memotong
        // proses yang sebenarnya masih berjalan normal. Lever UTAMA ada di
        // pemendekan budget TCP connect (15s->8s) di bawah -- itu yang
        // paling mungkin jadi titik "hang" saat FortiGate men-drop koneksi
        // diam-diam (lihat analisis log connectionTimeout berulang).
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 45),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 🚀 1. HTTP CLIENT ADAPTER (Solusi Tuntas Android <= 10)
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        // 🚀 Konsisten dengan BaseOptions.connectTimeout di atas (25s).
        client.connectionTimeout = const Duration(seconds: 25);

        // Helper: Cek otoritas bypass sertifikat
        bool isCertBypassAllowed(String host) {
          final parsedBaseHost = Uri.tryParse(EnvConfig.baseUrl)?.host ?? '';
          const allowedHosts = [
            'drivebapenda.surabaya.go.id',
            'apibapenda.surabaya.go.id',
          ];
          return host == parsedBaseHost || allowedHosts.contains(host);
        }

        // 🛡️ ANTI-REGRESI: Modifikasi alur pembuatan Socket untuk mem-bypass DNS OS bawaan.
        // Jika DNS gagal (kasus Android 10 kebawah), gunakan IP dari DoH.
        // Kemudian, socket mentah dibungkus manual dengan SecureSocket (TLS).
        client.connectionFactory =
            (Uri uri, String? proxyHost, int? proxyPort) async {
              final originalHost = uri.host;
              var targetHost = originalHost;

              try {
                //  FIX: naik dari 4s -> 8s. System resolver (3s) + 2 provider
                // DoH (3s masing-masing, sequential) butuh budget hingga ~9s
                // worst-case. Timeout 4s sebelumnya memotong DoH fallback
                // sebelum sempat jalan, sehingga fallback yang justru
                // dirancang untuk device/jaringan bermasalah nyaris tidak
                // pernah efektif.
                final resolvedIp = await ResilientDnsResolver.resolveIp(
                  originalHost,
                ).timeout(const Duration(seconds: 8));
                if (resolvedIp != null) targetHost = resolvedIp;
              } catch (_) {
                // Fallback aman ke hostname asli
              }

              // 🚀 FIX: budget TCP connection turun 15s -> 8s. Ini KEMUNGKINAN
              // BESAR titik sebenarnya di mana koneksi "hang" saat FortiGate
              // men-drop paket diam-diam (bukan DNS, bukan TLS) -- TCP
              // handshake yang BAKAL berhasil biasanya selesai dalam 1-3
              // detik. Memendekkan ini adalah cara tercepat memangkas waktu
              // tunggu user per percobaan.
              final connectTask = await Socket.startConnect(
                targetHost,
                uri.port,
              ).timeout(const Duration(seconds: 8));
              final rawSocket = await connectTask.socket;

              if (uri.scheme != 'https') {
                return ConnectionTask.fromSocket(
                  Future.value(rawSocket),
                  () => rawSocket.destroy(),
                );
              }

              try {
                // Budget TLS Handshake turun 10s -> 8s (konsisten dengan
                // outer connectTimeout 25s: DNS 8s + TCP 8s + TLS 8s = 24s).
                final secureSocket = await SecureSocket.secure(
                  rawSocket,
                  host: originalHost,
                  onBadCertificate: (cert) => isCertBypassAllowed(originalHost),
                ).timeout(const Duration(seconds: 8));

                return ConnectionTask.fromSocket(
                  Future.value(secureSocket),
                  () => secureSocket.destroy(),
                );
              } catch (e) {
                // 🧹 Hancurkan soket mentah jika TLS Handshake gagal/timeout!
                rawSocket.destroy();
                rethrow;
              }
            };

        return client;
      },
    );

    // 🚀 2. RETRY INTERCEPTOR (Otomatis mengetuk ulang endpoint jika gagal/delay lama)
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: (message) {
          if (kDebugMode) AppLogger.debug('>>> [DIO RETRY] 🔄 $message');
        },
        retries: 3,
        // 🚀 FIX: delay dipangkas. Reaksi terhadap FortiGate/jaringan yang
        // men-drop koneksi sesaat -- backoff panjang (2/5/10s) tidak banyak
        // membantu untuk skenario ini, delay singkat cukup dan signifikan
        // memangkas total waktu tunggu user.
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ],
        retryEvaluator: (error, attempt) {
          //  FIX: request FormData sekarang dibangun dari MultipartFile.fromBytes
          // (lihat absensi_model.dart & pengawasan_datasource.dart), bukan lagi
          // dari file stream — jadi risiko "double-stream crash" yang jadi
          // alasan blokir total retry sebelumnya sudah tidak berlaku.
          //
          // Tapi tetap perlu hati-hati soal DUPLIKAT submission: retry hanya
          // aman kalau dipastikan request BELUM SAMPAI ke server sama sekali
          // (gagal connect). Kalau sudah sempat kirim body lalu timeout
          // menunggu balasan (sendTimeout/receiveTimeout), retry berisiko
          // check-in/check-out tercatat dua kali di backend selama belum ada
          // idempotency key — jadi untuk fase ini kita TIDAK retry otomatis.
          if (error.requestOptions.data is FormData) {
            final safeToRetry =
                error.type == DioExceptionType.connectionError ||
                error.type == DioExceptionType.connectionTimeout;

            if (kDebugMode) {
              AppLogger.warning(
                '>>> [DIO RETRY] FormData (${error.type}): '
                '${safeToRetry ? "🔄 retry (belum sampai server)" : "🛑 skip (ambigu, cegah duplikat)"}',
              );
            }
            return safeToRetry;
          }
          return DefaultRetryEvaluator({
            ...defaultRetryableStatuses,
            status408RequestTimeout,
          }).evaluate(error, attempt);
        },
      ),
    );

    // 🚀 3. INTERCEPTOR LAINNYA
    // (Opsional: DnsDiagnosticInterceptor bisa dilepas karena ResilientDnsResolver sudah cukup memberikan log

    // 🚀 FIX: ConnectivityCheckInterceptor dipindah KELUAR dari kDebugMode
    // dan ditaruh PALING AWAL. Sebelumnya cuma aktif saat development --
    // padahal manfaatnya (fail-fast dengan pesan jelas saat HP benar-benar
    // offline total: mode pesawat/tidak ada sinyal) justru paling
    // dibutuhkan di lapangan (build production), bukan saat development.
    //
    // CATATAN PENTING: interceptor ini HANYA menangani kasus "device offline
    // total" (link-layer, WiFi/seluler mati). Untuk kasus koneksi ke server
    // spesifik yang di-drop FortiGate (device tetap online, cuma request ke
    // apibapenda.surabaya.go.id yang gagal) -- itu TIDAK terdeteksi di sini,
    // request tetap diteruskan dan baru gagal di connectionFactory (sudah
    // ditangani lewat tuning timeout & retry terpisah).
    //
    // Ditaruh SEBELUM authInterceptor supaya kalau memang offline total,
    // tidak perlu buang waktu ambil access token dari secure storage dulu.
    dio.interceptors.add(ConnectivityCheckInterceptor(connectivity));
    dio.interceptors.add(authInterceptor);

    if (kDebugMode) {
      //dio.interceptors.add(DebugMockInterceptor());
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          logPrint: (object) => AppLogger.debug(object.toString()),
        ),
      );
      dio.interceptors.add(ChuckerDioInterceptor());
    }

    return dio;
  }

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
