import 'dart:io';
import 'dart:math';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'objek_pajak_model.dart';
import 'transaction_model.dart';

class BayarRepository {
  // Fungsi untuk membuat Dio dengan konfigurasi SUPER LENGKAP tadi
  Dio _createDioInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        // STRATEGI 1: Perpanjang durasi timeout
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 45),
      ),
    );

    // Konfigurasi Adapter untuk SSL Handshake (Bypass SSL IP)
    // NOTE: Casting ke IOHttpClientAdapter wajib untuk platform Mobile (Android/iOS)
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();

      // STRATEGI 2: Timeout di level socket
      client.connectionTimeout = const Duration(seconds: 30);

      // --- INI KUNCI BYPASS SSL ERROR ---
      client
          .badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Logika: Jika host request ada di BASE_URL kita, izinkan (return true)
        final baseUrl = dotenv.env['BASE_URL'] ?? '';

        // Return true memaksa aplikasi "percaya" pada sertifikat IP tersebut
        if (baseUrl.contains(host)) return true;

        return true; // Force allow semua (gunakan dengan hati-hati) atau sesuaikan logic
      };
      return client;
    };

    // STRATEGI 3: Smart Retry
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: print,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 2),
          Duration(seconds: 5),
          Duration(seconds: 10),
        ],
        // Retry pada status 408 (Timeout) & socket exceptions
        retryableExtraStatuses: {408},
      ),
    );

    // Logger
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );

    // Chucker Inspector (Hanya muncul di Debug mode)
    if (kDebugMode) {
      dio.interceptors.add(ChuckerDioInterceptor());
    }

    return dio;
  }

  Future<List<ObjekPajakModel>> getObjekPajak() async {
    // 1. Panggil instance Dio yang sudah dikonfigurasi
    final dio = _createDioInstance();

    try {
      // 2. Lakukan Request
      // Karena baseUrl sudah diset di BaseOptions, kita cukup panggil endpoint-nya
      final response = await dio.get(
        '/ForDummy/GetObjekPajakParkirDigitalData',
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        final List data = response.data['data'];
        return data.map((e) => ObjekPajakModel.fromJson(e)).toList();
      } else {
        throw Exception("Gagal mengambil data: ${response.data['message']}");
      }
    } on DioException catch (e) {
      // Catch error spesifik Dio
      String errorMessage = "Terjadi kesalahan koneksi";
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Waktu koneksi habis. Cek sinyal internet Anda.";
      } else if (e.type == DioExceptionType.badCertificate) {
        errorMessage = "Sertifikat keamanan bermasalah (SSL).";
      } else if (e.response != null) {
        errorMessage = "Server Error: ${e.response?.statusCode}";
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Error tidak terduga: $e");
    }
  }

  // --- NEW: METHOD POST TRANSAKSI ---
  Future<TransactionModel> insertTransaction({
    required String nop,
    required String vehicleType,
    required String paymentMethod, // SOF
    required int amount, // Kredit
  }) async {
    final dio = _createDioInstance();

    // 1. LOGIC ACQUIRER (Sesuai Request)
    String acquirer = '';
    if (paymentMethod == 'BRIZZI') {
      acquirer = 'BRI';
    } else if (paymentMethod == 'TapCash') {
      acquirer = 'BNI';
    } else if (paymentMethod == 'Flazz') {
      acquirer = 'BCA';
    } else if (paymentMethod == 'QRIS') {
      acquirer = 'Bank Jatim';
    } else if (paymentMethod == 'e-Money') {
      acquirer = 'Bank Jatim'; // Sesuai request user
    } else {
      acquirer = 'Unknown Bank';
    }

    // 2. GENERATE RANDOM DATA
    final random = Random();
    // Generate Plat Nomor (Contoh: L 1234 XX)
    final platNomor =
        "L ${random.nextInt(8999) + 1000} ${String.fromCharCode(65 + random.nextInt(26))}${String.fromCharCode(65 + random.nextInt(26))}";
    // Generate Order ID & TRX random
    final orderId = "ORD-${DateTime.now().millisecondsSinceEpoch}";
    final noTrx = "TRX-${random.nextInt(999999)}";
    final noKartu = "KUE-${random.nextInt(99999999)}";
    final lat = "-7.2${random.nextInt(99999)}"; // Random sekitar Surabaya
    final long = "112.7${random.nextInt(99999)}";

    // 3. Susun Data Payload
    final requestData = TransactionModel(
      orderId: orderId,
      jenisTarif: vehicleType, // Mobil / Motor
      sof: paymentMethod, // QRIS / Flazz dll
      acquirer: acquirer, // Logic Bank tadi
      noKartuKue: noKartu,
      noTrx: noTrx,
      platNumber: platNomor,
      tglTrx: DateTime.now().toIso8601String(), // Waktu SEKARANG
      kredit: amount,
      saldo: 50000 + random.nextInt(500000), // Random saldo sisa
      kodeGate: "GT-${random.nextInt(10)}",
      namaGate: "Gate Utama ${random.nextInt(5)}",
      namaPetugas: "Petugas ${random.nextInt(20)}",
      latitude: lat,
      longitude: long,
      shift: "${random.nextInt(3) + 1}", // Shift 1, 2, atau 3
      nop: nop,
      jenisParkir: "On Street", // Default
    );

    try {
      // 4. HIT API
      final response = await dio.post(
        '/ForDummy/InsertTransaction',
        data: requestData.toJson(), // Kirim JSON
      );

      // Cek response, biasanya dummy API return object yang sama atau ID baru
      // Kita asumsikan sukses kalau 200/201
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Return data yang baru saja dikirim/dibalas server
        // Kalau server balikin JSON persis, pake response.data.
        // Tapi untuk aman (karena ini dummy), kita balikin requestData saja atau parse response.
        return requestData;
      } else {
        throw Exception("Gagal Insert: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error Post Transaksi: $e");
    }
  }
}
