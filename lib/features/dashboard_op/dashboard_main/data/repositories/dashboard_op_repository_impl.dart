import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/entities/dashboard_op_entity.dart';
import '../../domain/repositories/i_dashboard_op_repository.dart';
import '../datasources/dashboard_op_datasource.dart';
import '../mapper/dashboard_op_mapper.dart';

@LazySingleton(as: DashboardOpRepository)
class DashboardOpRepositoryImpl implements DashboardOpRepository {
  final DashboardOpDatasource _datasource;

  DashboardOpRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, DashboardOpEntity>> getSummaryDashboardOp(
    String nop,
  ) async {
    try {
      final response = await _datasource.getSummaryDashboardOp(nop);

      return Right(DashboardOpMapper.toEntity(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
