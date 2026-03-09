// lib/core/network/dio_auth_interceptor.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../storage/secure_stograge_manager.dart';

@lazySingleton
class DioAuthInterceptor extends Interceptor {
  final ISecureStorageManager _storage;

  DioAuthInterceptor(this._storage);

  /// 1. ON REQUEST: Tugasnya mencegat setiap request API yang keluar,
  /// lalu menyelipkan Access Token ke dalam header.
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _storage.getAccessToken();

    // Jika token ada, selipkan ke header Authorization
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return super.onRequest(options, handler);
  }

  /// 2. ON ERROR: Tugasnya menangkap error dari server.
  /// Jika error 401 (Unauthorized), kita lakukan Silent Refresh!
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Cek apakah errornya karena token basi (401)
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storage.getRefreshToken();

      // Jika Jukir tidak punya refresh token, langsung teruskan error (tendang ke login)
      if (refreshToken == null || refreshToken.isEmpty) {
        await _storage.clearAllTokens();
        return super.onError(err, handler);
      }

      try {
        // [SILENT REFRESH]
        // Kita buat instance Dio baru yang bersih (tanpa interceptor) agar tidak terjadi infinite loop
        final refreshDio = Dio();

        // Asumsi base URL Bapenda (sesuaikan dengan environment config Anda nanti)
        final baseUrl = err.requestOptions.baseUrl;

        // Tembak API Refresh Token (sesuai kesepakatan dengan BE)
        final response = await refreshDio.post(
          '$baseUrl/refresh-token',
          data: {'refresh_token': refreshToken},
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Yay! Dapat token baru dari BE
          final newAccessToken = response.data['access_token'];
          final newRefreshToken = response
              .data['refresh_token']; // Terkadang BE juga kasih refresh token baru

          // Simpan token baru ke brankas
          await _storage.saveAccessToken(newAccessToken);
          if (newRefreshToken != null) {
            await _storage.saveRefreshToken(newRefreshToken);
          }

          // [MOMEN AJAIB]
          // Ulangi request Jukir yang tadi gagal (misal: kirim data pelat) dengan token yang baru!
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          // Gunakan refreshDio untuk mengulang request agar tidak nyangkut
          final retryResponse = await refreshDio.fetch(requestOptions);

          // Kembalikan hasil yang sukses ke UI, seolah-olah tidak pernah terjadi error 401!
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        // Jika API refresh-token juga gagal (artinya refresh token sudah mati/expired),
        // hapus semua token di HP. UI (AppAuthCubit) nanti akan bereaksi dan menendang Jukir.
        await _storage.clearAllTokens();
        return super.onError(err, handler);
      }
    }

    // Jika errornya bukan 401 (misal 500 Server Error, 404 Not Found), biarkan lewat
    return super.onError(err, handler);
  }
}
