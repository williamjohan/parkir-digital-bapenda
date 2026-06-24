import 'dart:io';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../network/dio_auth_interceptor.dart';
import '../network/env_config.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio provideDio(DioAuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        // [STRATEGI 1: Extended Timeouts] - Adaptasi untuk upload foto & sinyal jalanan
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 45),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // [STRATEGI 3: Selective SSL Bypass & Prioritas IPv4]
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 30);

        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
              final baseUrl = EnvConfig.baseUrl;

              const allowedBypassHosts = <String>[
                'drivebapenda.surabaya.go.id',
              ];

              if (baseUrl.contains(host)) return true;
              if (allowedBypassHosts.contains(host)) return true;

              return false;
            };
        return client;
      },
    );

    // [STRATEGI 2: Smart Retry Interceptor]
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: print, // Bisa diganti dengan AppLogger.debug nantinya
        retries: 3, // Coba ulang 3 kali jika gagal koneksi
        retryDelays: const [
          Duration(seconds: 2),
          Duration(seconds: 5),
          Duration(seconds: 10),
        ],
        // Hanya mengulang jika error berupa timeout atau koneksi putus (bukan error 400/500 dari backend)
        retryableExtraStatuses: {status408RequestTimeout},
      ),
    );

    // 1. Masukkan AuthInterceptor (Satpam Token) kita
    dio.interceptors.add(authInterceptor);

    // 2. Masukkan LogInterceptor standar
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );

    // [STRATEGI 4: Network Inspector khusus Debug]
    // Catatan: Jika Anda ingin pakai Chucker, pastikan package chucker_flutter sudah di-install.
    // Jika tidak ingin pakai sekarang, bisa di-comment dulu blok ini.

    if (kDebugMode) {
      dio.interceptors.add(ChuckerDioInterceptor());
    }

    return dio;
  }

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
