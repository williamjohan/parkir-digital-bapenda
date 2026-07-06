import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../storage/secure_storage_manager.dart';
import '../utils/app_logger.dart';

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
    // TENDANG: Jika Backend membalas dengan 401 (Token Expired / Invalid)[cite: 2]
    if (err.response?.statusCode == 401) {
      AppLogger.error(
        '>>> [AUTH] 🚨 401 Unauthorized pada: ${err.requestOptions.path}',
      );
      AppLogger.warning('>>> [AUTH] 🧹 Membersihkan sesi aktif...');

      await _storage.saveLogoutReason('SESSION_EXPIRED');
      await _storage
          .clearAllTokens(); // AppAuthCubit akan menangkap ini[cite: 2]
    }

    return super.onError(err, handler);
  }
}
