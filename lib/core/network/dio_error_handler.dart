// lib/core/network/dio_error_handler.dart

import 'dart:io';
import 'package:dio/dio.dart';
import '../errors/exception.dart';
import '../utils/app_logger.dart'; // 🚀 [TAMBAHAN]: Import AppLogger Anda

class DioErrorHandler {
  static ServerException handle(DioException e) {
    // 1. Identifikasi Musuh Utama: Internet Mati atau Timeout
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.error is SocketException) {
      // 🚀 [LOGGING - WARNING]: Catat sebagai peringatan saja, bukan fatal error.
      AppLogger.warning(
        'Koneksi terputus saat mengakses: ${e.requestOptions.path}',
      );

      return const ServerException(
        statusCode: 0,
        message:
            'Koneksi internet terputus. Pastikan paket data atau Wi-Fi aktif.',
      );
    }

    // 2. Identifikasi Error dari Server (Backend merespons dengan 400, 401, 500, dll)
    final statusCode = e.response?.statusCode ?? 500;
    final message = e.response?.data?['message'] ?? 'Terjadi kesalahan server.';

    // 🚀 [LOGGING - ERROR]: Ini adalah bug dari server atau data yang salah, wajib dicatat sebagai Error!
    // Kita lempar 'e' dan 'e.stackTrace' ke parameter opsional AppLogger.
    AppLogger.error(
      'API Error [$statusCode] di endpoint: ${e.requestOptions.path}\nResponse: $message',
      e,
      e.stackTrace,
    );

    return ServerException(statusCode: statusCode, message: message);
  }
}
