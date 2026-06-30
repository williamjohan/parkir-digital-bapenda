import '../entities/dashboard_op_entity.dart';

abstract class DashboardOpRepository {
  Future<DashboardOpEntity> getSummaryDashboardOp(String nop);
}
