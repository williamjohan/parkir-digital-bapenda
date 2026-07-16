import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/detail_tax_surveillance_op/data/model/detail_tax_surveillance_op_model.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../domain/entities/detail_tax_surveillance_op_entity.dart';
import '../../domain/repositories/i_detail_tax_surveillance_op_repository.dart';
import '../datasources/detail_tax_surveillance_op_datasources.dart';

@LazySingleton(as: ITaxSurveillanceRepository)
class TaxSurveillanceRepositoryImpl implements ITaxSurveillanceRepository {
  final ITaxSurveillanceRemoteDataSource _remoteDataSource;

  TaxSurveillanceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<TaxSurveillanceDetailResponseEntity>>>
  getDefaultDetail(String nop) async {
    try {
      final models = await _remoteDataSource.getDefaultDetail(nop);
      return Right(models.toEntityList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(
        ServerFailure('Gagal memproses data default surveillance.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TaxSurveillanceDetailResponseEntity>>>
  getFilteredDetail(TaxSurveillanceRequestEntity requestEntity) async {
    try {
      AppLogger.debug(
        '>>> [REPO] Transforming RequestEntity to RequestModel for NOP: ${requestEntity.nop}',
      );

      final requestModel = requestEntity.toModel();

      final models = await _remoteDataSource.getFilteredDetail(requestModel);
      return Right(models.toEntityList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(
        ServerFailure('Gagal memproses data filter surveillance.'),
      );
    }
  }
}
