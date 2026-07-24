import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';
import 'package:parkir_digital_bapenda/core/storage/app_preferences.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper_2.dart';
import '../../../../core/storage/i_secure_storage_manager.dart';
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
  final AppPreferences _appPreferences;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._secureStorage,
    this._databaseHelper,
    this._appPreferences,
  );

  @override
  Future<Either<Failure, Unit>> login(String username, String password) async {
    try {
      await _secureStorage.clearAllTokens();
      await _databaseHelper.clearNopList();

      final response = await _remoteDataSource.login(username, password);

      if (response.accessToken.isNotEmpty) {
        //  1. HANYA SIMPAN ACCESS TOKEN
        await _secureStorage.saveAccessToken(response.accessToken);

        //  2. SIMPAN ROLE
        await _secureStorage.saveRoleId(response.roleLoginId);

        //  3. VALIDASI & SIMPAN UUID (Mekanisme Single Device)
        if (response.roleLoginId < 3 && response.uuidStatic.isNotEmpty) {
          await _secureStorage.saveDeviceUUID(response.uuidStatic);
        }

        //  4. SIMPAN NOP SECARA PARALEL
        if (response.nopList.isNotEmpty) {
          _simpanNopSecaraParalel(response.nopList);
        }

        //  5. SIMPAN OP LAST UPDATE
        if (response.lastUpdateOp.isNotEmpty) {
          await _secureStorage.saveOpLastUpdate(response.lastUpdateOp);
        }

        return const Right(unit);
      }
      return const Left(AuthFailure('Token tidak ditemukan dari server.'));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(AuthFailure('Terjadi kesalahan yang tidak terduga.'));
    }
  }

  void _simpanNopSecaraParalel(List<NopModel> nopList) {
    final sqliteData = AuthMapper.toSqliteList(nopList);
    _databaseHelper
        .saveNopList(sqliteData)
        .then((_) {
          AppLogger.info(
            ">>> AUDIT DATABASE: Berhasil insert ${nopList.length} NOP di background!",
          );
        })
        .catchError((e, stackTrace) {
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
      await _secureStorage.clearDeviceUUID();
      await _databaseHelper.clearNopList();
      await _appPreferences.clearAllPreferences();

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
    final profileRoleId = await _secureStorage.getRoleId();

    try {
      if (profileRoleId == RoleLoginDigitalParkir.pengawas.value) {
        return true;
      }

      return await _remoteDataSource.checkDeviceUuid();
    } catch (_) {
      return false;
    }
  }
}
