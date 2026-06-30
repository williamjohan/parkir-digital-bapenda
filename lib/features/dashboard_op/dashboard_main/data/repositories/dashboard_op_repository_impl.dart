import 'package:injectable/injectable.dart';

import '../../domain/entities/dashboard_op_entity.dart';
import '../../domain/repositories/dashboard_op_repository.dart';
import '../datasources/dashboard_op_datasource.dart';
import '../mapper/dashboard_op_mapper.dart';

@LazySingleton(as: DashboardOpRepository)
class DashboardOpRepositoryImpl implements DashboardOpRepository {
  final DashboardOpDatasource _datasource;

  DashboardOpRepositoryImpl(this._datasource);

  @override
  Future<DashboardOpEntity> getSummaryDashboardOp(String nop) async {
    final response = await _datasource.getSummaryDashboardOp(nop);

    return DashboardOpMapper.toEntity(response);
  }
}
