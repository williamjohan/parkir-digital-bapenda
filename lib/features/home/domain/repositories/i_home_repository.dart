import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/dashboard_summary_jukir/dashboard_summary_jukir_model.dart';
import '../entities/dashboard_summary_non_jukir_entity.dart';
import '../entities/dashboard_summary_pengawas.entity.dart';

abstract class IHomeRepository {
  /// Mengambil tarif dari API dan menyimpannya secara silent ke Secure Storage
  Future<Either<Failure, void>> syncTarif();

  /// Mengambil data dashboard dengan logika HYBRID (Jangkar Server + Delta Pending SQLite)
  Future<Either<Failure, DashboardSummaryJukirModel>> getDashboardSummaryJukir({
    required String nop,
  });

  Future<Either<Failure, DashboardSummaryNonJukirEntity>>
  getDashboardSummaryNonJukir();

  Future<Either<Failure, DashboardSummaryNonJukirEntity>>
  getDashboardSummaryNonJukirRange({String? tglAwal, String? tglAkhir});

  Future<Either<Failure, DashboardSummaryPengawasEntity>>
  getDashboardSummaryPengawas();
}
