import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/sub_features/detail_realisasi_op/data/mappers/detail_realisasi_op_mapper.dart';
import '../../domain/entities/detail_realisasi_op_entity.dart';
import '../../domain/repositories/detail_realisasi_op_repository.dart';
import '../datasources/detail_realisasi_op_datasources.dart';

@LazySingleton(as: DetailRealisasiOpRepository)
class DetailRealisasiOpRepositoryImpl implements DetailRealisasiOpRepository {
  final DetailRealisasiOpRemoteDataSource _remoteDataSource;

  DetailRealisasiOpRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, DetailRealisasiOpEntity>> getSummaryRealisasi({
    required String nop,
    required int tahun,
  }) async {
    try {
      final model = await _remoteDataSource.getSummaryRealisasi(
        nop: nop,
        tahun: tahun,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
