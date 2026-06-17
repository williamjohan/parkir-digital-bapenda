// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper_2.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;
  final DatabaseHelper2 _databaseHelper;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._secureStorage,
    this._databaseHelper,
  );

  @override
  Future<Either<Failure, Unit>> login(String username, String password) async {
    try {
      await _secureStorage.clearAllTokens();

      final response = await _remoteDataSource.login(username, password);

      if (response.accessToken.isNotEmpty) {
        // TOKEN
        await _secureStorage.saveAccessToken(response.accessToken);

        if (response.refreshToken.isNotEmpty) {
          await _secureStorage.saveRefreshToken(response.refreshToken);
        }

        // IS JUKIR
        await _secureStorage.saveIsJukir(response.isJukir);

        // UUID STATIC
        await _secureStorage.saveUuidStatic(response.uuidStatic);

        // JIKA NON JUKIR → TIMPA DEVICE ID
        if (!response.isJukir && response.uuidStatic.isNotEmpty) {
          await _secureStorage.saveDeviceId(response.uuidStatic);
        }

        // NOP LIST
        if (response.nopList.isNotEmpty) {
          await _databaseHelper.saveNopList(
            response.nopList.map((e) {
              return {
                'nop': e.nop.trim(),
                'nama_op': e.namaOp,
                'alamat_op': e.alamatOp,
              };
            }).toList(),
          );
        }

        return const Right(unit);
      }

      return const Left(AuthFailure('Token tidak ditemukan dari server.'));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Terjadi kesalahan yang tidak terduga.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _secureStorage.clearAllTokens();
      await _secureStorage.clearDeviceId();
      await _databaseHelper.clearNopList();
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure('Gagal melakukan logout lokal.'));
    }
  }

  @override
  Future<bool> checkAuthStatus() async {
    return await _secureStorage.hasValidToken();
  }

  @override
  Future<bool> checkDeviceUuid() async {
    try {
      return await _remoteDataSource.checkDeviceUuid();
    } catch (_) {
      return false;
    }
  }
}
