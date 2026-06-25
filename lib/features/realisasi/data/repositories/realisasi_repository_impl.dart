import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/realisasi_entity.dart';
import '../../domain/repositories/realisasi_repository.dart';
import '../datasources/realisasi_remote_datasource.dart';
import '../mappers/realisasi_mapper.dart'; // Import extension mapper Anda

@LazySingleton(as: RealisasiRepository)
class RealisasiRepositoryImpl implements RealisasiRepository {
  final RealisasiRemoteDataSource remoteDataSource;

  RealisasiRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<RealisasiEntity>>> getRealisasiSeluruhOp({
    required int tahun,
  }) async {
    try {
      final models = await remoteDataSource.getRealisasiSeluruhOp(tahun);
      final entities = models.toEntityList();
      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
