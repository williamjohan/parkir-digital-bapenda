// core/network/connectivity_check_interceptor.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../errors/exception.dart';

@lazySingleton
class ConnectivityCheckInterceptor extends Interceptor {
  final Connectivity _connectivity;
  ConnectivityCheckInterceptor(this._connectivity);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final result = await _connectivity.checkConnectivity();
    final hasConnection = !result.contains(ConnectivityResult.none);

    if (!hasConnection) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const ServerException(
            statusCode: 0,
            message:
                'Tidak ada koneksi internet. Aktifkan Wi-Fi atau paket data, lalu coba lagi.',
          ),
        ),
      );
    }

    return handler.next(options);
  }
}
