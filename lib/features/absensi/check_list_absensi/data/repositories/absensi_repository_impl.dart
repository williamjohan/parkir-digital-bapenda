import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/entities/absensi_entity.dart';
import '../../domain/repositories/i_absensi_repository.dart';
import '../datasources/absensi_dummy_datasource.dart';
import '../models/absensi_model.dart';

class AbsensiRepositoryImpl implements IAbsensiRepository {
  final IAbsensiDataSource dataSource;

  AbsensiRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, AbsensiEntity>> getAbsensiHariIni() async {
    try {
      final result = await dataSource.getAbsensiHariIni();
      return Right(result.toEntity());
    } catch (e) {
      // Handle spesifik exception di sini (DioException dll)
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AbsensiEntity>> submitAbsensi(
    AbsensiEntity entity,
  ) async {
    try {
      final modelData = AbsensiModel.fromEntity(entity);
      AbsensiModel result;

      if (entity.isPresent == false) {
        result = await dataSource.submitAbsenMasuk(modelData);
      } else {
        result = await dataSource.submitAbsenPulang(modelData);
      }

      // Mengembalikan response hasil POST sebagai Entity baru untuk UI
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
