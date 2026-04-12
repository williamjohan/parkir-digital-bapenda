// lib/core/network/dio_error_handler.dart

import 'dart:io';
import 'package:dio/dio.dart';
import '../errors/exception.dart';

class DioErrorHandler {
  static ServerException handle(DioException e) {
    // 1. Identifikasi Musuh Utama: Internet Mati atau Timeout
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.error is SocketException) {
      return const ServerException(
        statusCode:
            0, // Angka 0 menandakan error jaringan (bukan error dari server)
        message:
            'Koneksi internet terputus. Pastikan paket data atau Wi-Fi aktif.',
      );
    }

    // 2. Identifikasi Error dari Server (Backend merespons dengan 400, 401, 500, dll)
    final statusCode = e.response?.statusCode ?? 500;

    // Asumsi Backend Bapenda selalu mengirim pesan error di key 'message'
    // Jika bentuk JSON error-nya berbeda, Anda bisa menyesuaikan logic parsing-nya di sini
    final message = e.response?.data?['message'] ?? 'Terjadi kesalahan server.';

    return ServerException(statusCode: statusCode, message: message);
  }
}
