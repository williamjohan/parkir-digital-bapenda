// lib/core/errors/exceptions.dart

/// Base class untuk semua custom exception di aplikasi Bapenda.
/// Wajib memiliki [message] agar UI selalu punya pesan untuk ditampilkan.
abstract class AppException implements Exception {
  final String message;
  const AppException({required this.message});
}

class ServerException extends AppException {
  final int statusCode;

  // message wajib diisi saat dilempar oleh Data Source
  const ServerException({required this.statusCode, required super.message});
}

class CacheException extends AppException {
  const CacheException({super.message = 'Gagal memproses data lokal.'});
}

class CameraException extends AppException {
  const CameraException({
    super.message = 'Terjadi kesalahan pada modul kamera.',
  });
}

class OcrException extends AppException {
  const OcrException({super.message = 'Gagal memproses teks dari gambar.'});
}

// AuthException sekarang resmi menjadi bagian dari keluarga AppException
class AuthException extends AppException {
  const AuthException({required super.message});
}
