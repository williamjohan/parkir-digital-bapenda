import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/failure.dart';
import '../entities/dashboard_op_entity.dart';
import '../repositories/i_dashboard_op_repository.dart';

@lazySingleton
class GetSummaryDashboardOpUsecase {
  final DashboardOpRepository _repository;

  GetSummaryDashboardOpUsecase(this._repository);

  Future<Either<Failure, DashboardOpEntity>> call(String nop) {
    return _repository.getSummaryDashboardOp(nop);
  }

  //Helper untuk dipakai darmo di cubit return bool true / false
  bool getTSInfo(DashboardOpEntity dashboard) {
    return dashboard.hasTs && dashboard.taxSurveillance != null;
  }
}
