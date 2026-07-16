import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../entities/dashboard_op_entity.dart';

abstract class DashboardOpRepository {
  Future<Either<Failure, DashboardOpEntity>> getSummaryDashboardOp(String nop);
}
