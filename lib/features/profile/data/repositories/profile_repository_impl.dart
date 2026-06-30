import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/utils/qris_image_helper.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

@LazySingleton(as: IProfileRepository)
class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  ProfileRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, UserEntity>> getProfileInfo({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final localResult = await _getLocalProfileInfo();

      // Jika di lokal ada, langsung kembalikan!
      if (localResult.isRight()) {
        return localResult;
      }
    }

    return await _syncProfileInfo();
  }

  @override
  Future<Either<Failure, String>> getProfilePicturePath({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final localResult = await _getLocalProfilePicturePaths();

      if (localResult.isRight()) {
        return localResult;
      }
    }

    return await _syncProfilePictureToLocal();
  }

  Future<Either<Failure, UserEntity>> _syncProfileInfo() async {
    try {
      final userModel = await _remoteDataSource.getProfile();

      await _secureStorage.saveJukirProfile(
        idUserStorage: userModel.idUser,
        namaUserStorage: userModel.namaUser,
        username: userModel.username,
        nopStorage: userModel.nop,
        pungutTarif: userModel.pungutTarif,
        pungutTarifDescription: userModel.pungutTarifDescription,
        namaObjekPajak: userModel.namaObjekPajak,
        idDevice: userModel.idDevice,
        lokasiId: userModel.lokasiId,
        namaLokasi: userModel.namaLokasi,
        kodeGate: userModel.kodeGate,
        namaGate: userModel.namaGate,
        shift: userModel.shift,
        alamat: userModel.alamat,
      );

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(
        ServerFailure('Terjadi kesalahan tidak terduga saat memuat profil.'),
      );
    }
  }

  Future<Either<Failure, UserEntity>> _getLocalProfileInfo() async {
    try {
      final profileMap = await _secureStorage.getJukirProfile();

      if (profileMap != null) {
        try {
          final entity = UserModel.fromJson(profileMap).toEntity();
          return Right(entity);
        } catch (e) {
          AppLogger.error('>>> [ProfileRepository] JSON Corrupt: $e');
          await _secureStorage
              .clearJukirProfile(); // Bersihkan data yang corrupt
          return const Left(
            CacheFailure('Data profil rusak atau tidak valid.'),
          );
        }
      }

      return const Left(
        CacheFailure('Profil lokal tidak ditemukan di brankas.'),
      );
    } catch (e) {
      AppLogger.error(
        '>>> [ProfileRepository] Error saat mengambil profil lokal: $e',
      );
      return const Left(
        CacheFailure('Gagal membaca profil dari penyimpanan lokal.'),
      );
    }
  }

  Future<Either<Failure, String>> _syncProfilePictureToLocal() async {
    try {
      // 1. Ambil data Base64 dari Remote Data Source
      final responseModel = await _remoteDataSource.getProfilePhoto();

      // 2. Jika foto dari server kosong, bersihkan storage lokal
      if (responseModel.fotoPostcard.isEmpty) {
        await _secureStorage.clearProfilePicture();
        return const Right('');
      }

      // 3. Ambil username untuk nama file dinamis
      final profile = await _secureStorage.getJukirProfile();
      final username = profile?['username']?.toString() ?? 'default_user';

      // 4. Suruh Utility mengubah Base64 jadi file fisik
      final localPath = await Base64ImageHelper.saveProfileBase64ToFile(
        username: username,
        base64String: responseModel.fotoPostcard,
      );

      // 5. Simpan PATH FILE TERSEBUT ke Secure Storage Anda
      await _secureStorage.saveProfilePicture(localPath);

      return Right(localPath);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(
        ServerFailure(
          'Terjadi kesalahan sistem saat sinkronisasi foto profil.',
        ),
      );
    }
  }

  Future<Either<Failure, String>> _getLocalProfilePicturePaths() async {
    try {
      final path = await _secureStorage.getProfilePicture();

      if (path != null && path.isNotEmpty) {
        final file = File(path);

        if (await file.exists()) {
          return Right(path);
        } else {
          AppLogger.warning(
            '>>> [ProfileRepository] File foto fisik hilang! Membersihkan storage...',
          );
          await _secureStorage.clearProfilePicture();
          return const Left(
            CacheFailure('File fisik foto profil tidak ditemukan.'),
          );
        }
      }

      // Jika memang belum pernah simpan foto
      return const Left(CacheFailure('Belum ada foto profil yang tersimpan.'));
    } catch (e) {
      AppLogger.error(
        '>>> [ProfileRepository] Error saat membaca path lokal: $e',
      );
      return const Left(CacheFailure('Gagal membaca penyimpanan lokal.'));
    }
  }
}
