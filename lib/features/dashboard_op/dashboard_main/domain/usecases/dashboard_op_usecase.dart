import 'package:injectable/injectable.dart';

import '../entities/dashboard_op_entity.dart';
import '../repositories/dashboard_op_repository.dart';

@lazySingleton
class GetSummaryDashboardOpUsecase {
  final DashboardOpRepository _repository;

  GetSummaryDashboardOpUsecase(this._repository);

  Future<DashboardOpEntity> call(String nop) async {
    return _repository.getSummaryDashboardOp(nop);
  }
}
