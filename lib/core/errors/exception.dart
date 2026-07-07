/// Base class untuk semua custom exception di aplikasi Bapenda.
/// Wajib memiliki [message] agar UI selalu punya pesan untuk ditampilkan.
abstract class AppException implements Exception {
  final String message;
  const AppException({required this.message});

  //override untuk savety net ketika tempat lain lupa e.message biar ga instance of exception
  @override
  String toString() => message;
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

class LocationDisabledException extends AppException {
  const LocationDisabledException({
    super.message = 'GPS (Lokasi) tidak aktif.',
  });
}

class LocationPermissionDeniedException extends AppException {
  const LocationPermissionDeniedException({
    super.message = 'Izin lokasi ditolak.',
  });
}
