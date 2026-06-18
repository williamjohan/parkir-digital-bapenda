import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../repositories/i_home_repository.dart';

@lazySingleton
class GetHybridDashboardSummaryUseCase {
  final IHomeRepository repository;

  GetHybridDashboardSummaryUseCase(this.repository);

  Future<Either<Failure, DashboardSummaryModel>> execute({
    required String nop,
  }) {
    return repository.getHybridDashboardSummary(nop: nop);
  }
}
