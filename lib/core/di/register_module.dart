// lib/core/di/register_module.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../network/dio_auth_interceptor.dart';

@module
abstract class RegisterModule {
  // Daftarkan Dio sebagai Singleton, dan minta GetIt untuk menyuntikkan (inject)
  // DioAuthInterceptor yang sudah kita buat tadi ke fungsi ini.
  @lazySingleton
  Dio provideDio(DioAuthInterceptor authInterceptor) {
    // 1. Inisialisasi dasar Dio
    final dio = Dio(
      BaseOptions(
        // TODO: Ganti dengan Base URL API Bapenda yang sesungguhnya nanti
        baseUrl: 'https://api.bapenda.surabaya.go.id/api/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 2. Pasang Satpam Jaringan (Auth Interceptor) kita!
    dio.interceptors.add(authInterceptor);

    // 3. (Opsional & Sangat Disarankan) Pasang Log Interceptor bawaan Dio
    // agar Anda bisa melihat request/response API di terminal/console dengan jelas.
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );

    return dio;
  }
}
