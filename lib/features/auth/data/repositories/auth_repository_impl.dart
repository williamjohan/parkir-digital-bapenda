import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);
  @override
  Future<Either<Failure, Unit>> login(String username, String password) async {
    try {
      // 1. response sekarang otomatis bertipe AuthResponseModel, bukan Map liar lagi!
      final response = await _remoteDataSource.login(username, password);

      if (response.accessToken.isNotEmpty) {
        // 2. Simpan Token
        await _secureStorage.saveAccessToken(response.accessToken);
        if (response.refreshToken.isNotEmpty) {
          await _secureStorage.saveRefreshToken(response.refreshToken);
        }

        // 3. Simpan Profil Jukir (Sangat bersih dan Type-Safe!)
        await _secureStorage.saveJukirProfile(
          idUserStorage: response.user.idUser,
          namaUserStorage: response.user.namaUser,
          nopStorage: response.user.nop,
        );

        return const Right(unit);
      } else {
        return const Left(AuthFailure('Token tidak ditemukan dari server.'));
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Terjadi kesalahan yang tidak terduga.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      // Hapus token di HP agar Jukir ditendang dari sesi
      await _secureStorage.clearAllTokens();
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure('Gagal melakukan logout lokal.'));
    }
  }

  @override
  Future<bool> checkAuthStatus() async {
    return await _secureStorage.hasValidToken();
  }
}
