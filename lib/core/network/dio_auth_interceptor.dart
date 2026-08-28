import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../storage/i_secure_storage_manager.dart';
import '../utils/app_logger.dart';

@lazySingleton
class DioAuthInterceptor extends Interceptor {
  final ISecureStorageManager _storage;
  bool _isHandling401 = false;

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
      // 🚀 2. CEK GEMBOK: Hanya eksekusi jika belum ada proses 401 yang berjalan
      if (!_isHandling401) {
        _isHandling401 = true; // Kunci gembok!

        try {
          AppLogger.error(
            '>>> [AUTH] 🚨 401 Unauthorized pada: ${err.requestOptions.path}',
          );
          AppLogger.warning('>>> [AUTH] 🧹 Membersihkan sesi aktif...');

          await _storage.saveLogoutReason('SESSION_EXPIRED');

          // Proses ini sekarang aman dari eksekusi ganda
          await _storage.clearAllTokens();

          // Opsional/Tech Debt: Idealnya di sini kita juga menembakkan sebuah Event/Stream
          // yang didengarkan oleh AppAuthCubit agar UI terlempar ke layar Login secara halus,
          // sekaligus membersihkan DatabaseHelper2 dan AppPreferences.
        } catch (e) {
          AppLogger.error('>>> [AUTH] Gagal membersihkan sesi: $e');
        } finally {
          // Buka gembok kembali setelah jeda yang cukup (misal 3 detik)
          // untuk memastikan API lain yang gagal berbarengan tidak memicu proses ini lagi.
          Future.delayed(const Duration(seconds: 3), () {
            _isHandling401 = false;
          });
        }
      } else {
        AppLogger.warning(
          '>>> [AUTH] 🚨 401 terdeteksi lagi, tapi proses pembersihan sudah berjalan. (Ignored)',
        );
      }
    }

    return super.onError(err, handler);
  }
}
