/// Base class untuk semua custom exception di aplikasi Bapenda.
/// Wajib memiliki [message] agar UI selalu punya pesan untuk ditampilkan.
abstract class AppException implements Exception {
  final String message;
  const AppException({required this.message});
}

class ServerException extends AppException {
  final int statusCode;
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

class AuthException extends AppException {
  const AuthException({required super.message});
}

class LocationDisabledException implements Exception {
  final String message;
  LocationDisabledException([this.message = 'GPS (Lokasi) tidak aktif.']);
}

class LocationPermissionDeniedException implements Exception {
  final String message;
  LocationPermissionDeniedException([this.message = 'Izin lokasi ditolak.']);
}
