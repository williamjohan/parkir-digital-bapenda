import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/dashboard_summary_model.dart';
import '../../data/models/tarif_model.dart';
import '../../data/models/weekly_chart_item_model.dart';

abstract class IHomeRepository {
  /// Mengambil tarif dari API dan menyimpannya secara silent ke Secure Storage
  Future<Either<Failure, void>> syncTarif();

  /// Mengambil data dashboard dengan logika HYBRID (Jangkar Server + Delta Pending SQLite)
  Future<Either<Failure, DashboardSummaryModel>> getHybridDashboardSummary();

  /// Mengambil data grafik mingguan
  Future<Either<Failure, List<WeeklyChartItemModel>>> getWeeklyChart();

  // /// Mengambil tarif kendaraan
  // Future<Either<Failure, List<TarifModel>>> getLocalTarifs();
}
