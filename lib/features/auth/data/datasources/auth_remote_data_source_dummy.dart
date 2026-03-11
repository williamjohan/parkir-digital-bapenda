import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/utils/app_logger.dart';
import '../../../../core/errors/exception.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSourceDummyImpl implements IAuthRemoteDataSource {
  @override
  Future<AuthResponseModel> login(String username, String password) async {
    AppLogger.warning("⚠️ [WARNING] MENGGUNAKAN DUMMY API LOGIN!");
    await Future.delayed(const Duration(seconds: 2));

    if (username == 'willi' && password == '123456') {
      return AuthResponseModel(
        accessToken: 'dummy_access_token_super_rahasia_123',
        refreshToken: 'dummy_refresh_token_anti_basi_456',
        user: UserModel(
          idJukir: 'JUKIR-BPD-001',
          nama: 'William',
          nop: 'NOP-SBY-99887766',
        ),
      );
    } else {
      throw const AuthException(
        message: 'Username atau password Jukir salah (Dari Dummy).',
      );
    }
  }
}
