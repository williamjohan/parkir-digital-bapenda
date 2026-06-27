import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/dashboard_summary_non_jukir_entity.dart';
import '../repositories/i_home_repository.dart';

@lazySingleton
class GetDashboardSummaryNonJukirRangeUseCase {
  final IHomeRepository repository;

  GetDashboardSummaryNonJukirRangeUseCase(this.repository);

  Future<Either<Failure, DashboardSummaryNonJukirEntity>> execute({
    String? tglAwal,
    String? tglAkhir,
  }) {
    return repository.getDashboardSummaryNonJukirRange(
      tglAwal: tglAwal,
      tglAkhir: tglAkhir,
    );
  }
}
