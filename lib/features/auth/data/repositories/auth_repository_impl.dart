// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

@LazySingleton(as: IAuthRepository)
@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  // 1. KEMBALIKAN KE TIPE 'Unit'
  Future<Either<Failure, Unit>> login(String username, String password) async {
    try {
      final response = await _remoteDataSource.login(username, password);

      final accessToken = response['access_token'];
      final refreshToken = response['refresh_token'];
      final userData = response['user'] as Map<String, dynamic>?;

      if (accessToken != null && userData != null) {
        await _secureStorage.saveAccessToken(accessToken);
        if (refreshToken != null) {
          await _secureStorage.saveRefreshToken(refreshToken);
        }

        // 2. SESUAIKAN DENGAN PARAMETER BARU ANDA (namaJukir)
        await _secureStorage.saveJukirProfile(
          idJukir: userData['id_jukir'] ?? '',
          namaJukir: userData['nama'] ?? '',
          nop: userData['nop'] ?? '',
        );

        // 3. KEMBALIKAN 'unit' DARI PACKAGE dartz, BUKAN 'true'
        return const Right(unit);
      } else {
        return const Left(AuthFailure('Format response API tidak valid.'));
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
