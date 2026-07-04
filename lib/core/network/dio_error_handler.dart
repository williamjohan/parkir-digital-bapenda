import 'dart:io';
import 'package:dio/dio.dart';
import '../errors/exception.dart';
import '../utils/app_logger.dart';

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
    final message = _extractMessage(e.response?.data);

    AppLogger.error(
      'API Error [$statusCode] di endpoint: ${e.requestOptions.path}\nResponse: ${e.response?.data}',
      e,
      e.stackTrace,
    );

    return ServerException(statusCode: statusCode, message: message);
  }

  /// 🔥 Ekstrak message dengan aman, apapun bentuk response body-nya
  static String _extractMessage(dynamic data) {
    try {
      if (data is Map) {
        final msg = data['message'] ?? data['Message'] ?? data['error'];

        if (msg is String && msg.isNotEmpty) return msg;

        // Kalau message berupa List (misal error validasi array)
        if (msg is List && msg.isNotEmpty) {
          return msg.join(', ');
        }
      }

      if (data is String && data.isNotEmpty) {
        // Body plain text/HTML, jangan ditampilkan mentah-mentah ke user
        return 'Terjadi kesalahan pada server.';
      }
    } catch (_) {
      // fallback di bawah kalau parsing tetap gagal
    }

    return 'Terjadi kesalahan server.';
  }
}