import 'dart:io';
import 'package:dio/dio.dart';
import '../errors/exception.dart';
import '../utils/app_logger.dart'; // 🚀 [TAMBAHAN]: Import AppLogger Anda

class DioErrorHandler {
  static ServerException handle(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.error is SocketException) {
      AppLogger.warning(
        'Koneksi terputus saat mengakses: ${e.requestOptions.path}',
      );

      return const ServerException(
        statusCode: 0,
        message:
            'Koneksi internet terputus. Pastikan paket data atau Wi-Fi aktif.',
      );
    }
    final statusCode = e.response?.statusCode ?? 500;
    final message = e.response?.data?['message'] ?? 'Terjadi kesalahan server.';
    AppLogger.error(
      'API Error [$statusCode] di endpoint: ${e.requestOptions.path}\nResponse: $message',
      e,
      e.stackTrace,
    );

    return ServerException(statusCode: statusCode, message: message);
  }
}
