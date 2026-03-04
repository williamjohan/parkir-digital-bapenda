abstract class AppException implements Exception {
  final String? message;
  const AppException({this.message});
}

class ServerException extends AppException {
  final int statusCode;
  const ServerException({required this.statusCode, super.message});
}

class CacheException extends AppException {
  const CacheException({super.message = 'Gagal memproses data lokal.'});
}

/// Digunakan ketika inisialisasi kamera gagal, atau izin akses ditolak.
class CameraException extends AppException {
  const CameraException({
    super.message = 'Terjadi kesalahan pada modul kamera.',
  });
}

/// Digunakan ketika ML Kit gagal load, atau gagal membaca teks dari frame.
class OcrException extends AppException {
  const OcrException({super.message = 'Gagal memproses teks dari gambar.'});
}
