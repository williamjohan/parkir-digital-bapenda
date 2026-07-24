import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/data/models/absensi_model.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/domain/entities/alat_digital_entity.dart';
import '../../../../../core/errors/exception.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/entities/absensi_entity.dart';
import '../../domain/repositories/i_absensi_repository.dart';
import '../datasources/absensi_remote_datasource.dart';

@LazySingleton(as: IAbsensiRepository)
class AbsensiRepositoryImpl implements IAbsensiRepository {
  final IAbsensiRemoteDataSource remoteDataSource;

  AbsensiRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> postAbsensi(AbsensiEntity absensi) async {
    try {
      // Mapping dari Entity (Domain) ke Model (Data)
      final requestModel = absensi.toModel();
      await remoteDataSource.postAbsensi(requestModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AlatDigitalEntity>>> getAlatDigital() async {
    try {
      final models = await remoteDataSource.getAlatDigital();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
