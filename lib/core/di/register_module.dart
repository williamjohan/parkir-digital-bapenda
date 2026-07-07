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
        connectTimeout: const Duration(seconds: 30),
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
        client.connectionTimeout = const Duration(seconds: 30);

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

              // Budget TCP connection 15 detik
              final connectTask = await Socket.startConnect(
                targetHost,
                uri.port,
              ).timeout(const Duration(seconds: 15));
              final rawSocket = await connectTask.socket;

              if (uri.scheme != 'https') {
                return ConnectionTask.fromSocket(
                  Future.value(rawSocket),
                  () => rawSocket.destroy(),
                );
              }

              try {
                // Budget TLS Handshake 10 detik
                final secureSocket = await SecureSocket.secure(
                  rawSocket,
                  host: originalHost,
                  onBadCertificate: (cert) => isCertBypassAllowed(originalHost),
                ).timeout(const Duration(seconds: 10));

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
        retries: 3, // Coba hingga 3x[cite: 5]
        retryDelays: const [
          Duration(seconds: 2), // Ketukan pertama cepat
          Duration(seconds: 5), // Ketukan kedua agak direnggangkan
          Duration(seconds: 10), // Ketukan terakhir
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
    // (Opsional: DnsDiagnosticInterceptor bisa dilepas karena ResilientDnsResolver sudah cukup memberikan log[cite: 3, 4])
    dio.interceptors.add(authInterceptor);

    if (kDebugMode) {
      dio.interceptors.add(ConnectivityCheckInterceptor(connectivity));
      // dio.interceptors.add(DebugMockInterceptor());
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
