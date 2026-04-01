// lib/features/profile/data/repositories/profile_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

@LazySingleton(as: IProfileRepository)
class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  ProfileRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      final userModel = await _remoteDataSource.getProfile();

      await _secureStorage.saveJukirProfile(
        idUserStorage: userModel.idUser,
        namaUserStorage: userModel.namaUser,
        nopStorage: userModel.nop,
        pungutTarif: userModel.pungutTarif,
        namaObjekPajak: userModel.namaObjekPajak,
        idDevice: userModel.idDevice,
        lokasiId: userModel.lokasiId,
        namaLokasi: userModel.namaLokasi,
        kodeGate: userModel.kodeGate,
        namaGate: userModel.namaGate,
        shift: userModel.shift,
      );

      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(
        ServerFailure('Terjadi kesalahan tidak terduga saat memuat profil.'),
      );
    }
  }
}
