import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/jadwal/data/model/jadwal_model.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/jadwal_entity.dart';
import '../../domain/repositories/i_jadwal_repositories.dart';
import '../datasources/jadwal_remote_datasource.dart';

@LazySingleton(as: IJadwalRepository)
class JadwalRepositoryImpl implements IJadwalRepository {
  final IJadwalRemoteDataSource _remoteDataSource;

  JadwalRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<JadwalEntity>>> getJadwalInfo({
    bool forceRefresh = false,
  }) async {
    try {
      final listJadwalModel = await _remoteDataSource.getJadwalInfo();
      return Right(listJadwalModel.toEntityList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure("Gagal memuat data jadwal."));
    }
  }
}
