import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../storage/secure_storage_manager.dart';
import '../utils/app_logger.dart'; // 🚀 Tetap pertahankan CCTV kita

@lazySingleton
class DioAuthInterceptor extends Interceptor {
  final ISecureStorageManager _storage;

  DioAuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _storage.getAccessToken();

    // 🚀 TEMPEL: Jika ada token di brankas, tempelkan ke header
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 🚀 TENDANG: Jika Backend membalas dengan 401 (Token Expired / Invalid)
    if (err.response?.statusCode == 401) {
      AppLogger.error(
        '>>> [AuthInterceptor] 🚨 401 Unauthorized terdeteksi pada: ${err.requestOptions.path}',
      );
      AppLogger.warning(
        '>>> [AuthInterceptor] 🧹 Sesi berakhir! Membersihkan brankas token...',
      );

      // 1. Catat alasan logout untuk keperluan debugging / tracking
      await _storage.saveLogoutReason('SESSION_EXPIRED');

      // 2. Sapu bersih token agar sistem (AppAuthCubit) tahu sesi sudah mati
      await _storage.clearAllTokens();
    }

    // Lanjutkan lempar error ke Repository agar ditangkap sebagai ServerException / AuthException
    return super.onError(err, handler);
  }
}
