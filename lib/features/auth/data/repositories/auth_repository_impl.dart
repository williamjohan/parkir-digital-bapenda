// lib/features/auth/data/repositories/auth_repository_impl.dart

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
      // 1. Suruh Data Source menembak API
      final data = await _remoteDataSource.login(username, password);

      // 2. Ekstrak dua token rahasia kita
      final accessToken = data['access_token'];
      final refreshToken = data['refresh_token'];

      if (accessToken != null && refreshToken != null) {
        // 3. Simpan aman-aman ke dalam brankas (Secure Storage)
        await _secureStorage.saveAccessToken(accessToken);
        await _secureStorage.saveRefreshToken(refreshToken);

        return const Right(unit); // Berhasil!
      } else {
        return const Left(
          ServerFailure('Format token dari server tidak valid.'),
        );
      }
    } on AuthException catch (e) {
      // Sangat bersih! e.message dijamin String non-nullable
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      // Sangat bersih! Bisa langsung dipassing ke ServerFailure
      // Boleh juga kita tambahkan statusCode agar lebih informatif
      return Left(ServerFailure('${e.message} (Code: ${e.statusCode})'));
    } catch (e) {
      // Tangkapan terakhir untuk error di luar sistem kita (misal: FormatException)
      return const Left(
        ServerFailure('Terjadi kesalahan sistem yang tidak diketahui.'),
      );
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
