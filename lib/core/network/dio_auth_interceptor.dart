// lib/core/network/dio_auth_interceptor.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../storage/secure_storage_manager.dart';
import 'api_endpoints.dart';
import 'env_config.dart';

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
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        await _storage.clearAllTokens();
        return super.onError(err, handler);
      }

      try {
        // [PERBAIKAN ARSITEKTUR]: Gunakan EnvConfig.baseUrl agar instance Dio baru ini tidak buta arah
        final refreshDio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

        // [PERBAIKAN]: Gunakan konstanta dari ApiEndpoints
        final response = await refreshDio.post(
          ApiEndpoints.refreshToken,
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final newAccessToken = response.data['data'] as String;
          await _storage.saveAccessToken(newAccessToken);

          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await refreshDio.fetch(requestOptions);
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        await _storage.clearAllTokens();
        return super.onError(err, handler);
      }
    }

    return super.onError(err, handler);
  }
}
