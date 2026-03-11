// lib/features/auth/data/datasources/auth_remote_data_source_dummy.dart

import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/utils/app_logger.dart';
import '../../../../core/errors/exception.dart';
import 'auth_remote_data_source.dart'; // Import interface-nya

// HIDUPKAN SAKLAR DI SINI!
// GetIt akan menyuntikkan kelas ini setiap kali ada yang meminta IAuthRemoteDataSource
@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSourceDummyImpl implements IAuthRemoteDataSource {
  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    AppLogger.warning("⚠️ [WARNING] MENGGUNAKAN DUMMY API LOGIN!");

    // 1. Simulasi delay jaringan Bapenda (2 detik)
    await Future.delayed(const Duration(seconds: 2));

    // 2. Simulasi sukses (Skenario Happy Path)
    if (username == 'willi' && password == '123456') {
      return {
        'access_token': 'dummy_access_token_super_rahasia_123',
        'refresh_token': 'dummy_refresh_token_anti_basi_456',
      };
    }
    // 3. Simulasi gagal (Skenario Negative Path)
    else {
      throw const AuthException(
        message: 'Username atau password Jukir salah (Dari Dummy).',
      );
    }
  }
}
