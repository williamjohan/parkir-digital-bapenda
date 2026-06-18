// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper_2.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mappers/auth_mapper.dart';
import '../models/auth_response_model.dart';

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
      await _databaseHelper.clearNopList();

      final response = await _remoteDataSource.login(username, password);

      if (response.accessToken.isNotEmpty) {
        // 1. SIMPAN TOKEN
        await _secureStorage.saveAccessToken(response.accessToken);
        if (response.refreshToken.isNotEmpty) {
          await _secureStorage.saveRefreshToken(response.refreshToken);
        }

        // 2. SIMPAN ROLE (Pengganti isJukir)
        await _secureStorage.saveRoleId(response.roleLoginId);

        // 3. SIMPAN UUID STATIC
        await _secureStorage.saveUuidStatic(response.uuidStatic);

        // 4. JIKA NON-JUKIR → TIMPA DEVICE ID
        // Asumsi: Role Jukir adalah 3 (Atur sesuai Enum Master Role Anda)
        if (response.roleLoginId != 3 && response.uuidStatic.isNotEmpty) {
          await _secureStorage.saveDeviceId(response.uuidStatic);
        }

        // 5. FIRE-AND-FORGET: Simpan NOP ke SQLite secara Paralel!
        // Jika list kosong (bukan Jukir), fungsi ini tidak akan tereksekusi.
        if (response.nopList.isNotEmpty) {
          _simpanNopSecaraParalel(response.nopList);
        }

        // Proses login langsung Return Unit tanpa menunggu insert ratusan SQLite!
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

  void _simpanNopSecaraParalel(List<NopModel> nopList) {
    // 1. Panggil Mapper untuk membersihkan format DTO ke Map SQLite
    final sqliteData = AuthMapper.toSqliteList(nopList);

    // 2. Eksekusi tanpa "await"
    _databaseHelper
        .saveNopList(sqliteData)
        .then((_) {
          AppLogger.info(
            ">>> AUDIT DATABASE: Berhasil insert ${nopList.length} NOP di background!",
          );
        })
        .catchError((e, stackTrace) {
          // Selalu tangkap stackTrace di logger untuk mempermudah debugging
          AppLogger.error(
            ">>> AUDIT DATABASE ERROR: Gagal insert NOP: $e",
            e,
            stackTrace,
          );
        });
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
