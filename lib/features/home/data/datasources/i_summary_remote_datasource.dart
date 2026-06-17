import '../models/dashboard_summary_model.dart';
import '../models/weekly_chart_item_model.dart';

abstract class ISummaryRemoteDataSource {
  Future<DashboardSummaryModel> getDashboardSummary({required String nop});

  Future<List<WeeklyChartItemModel>> getWeeklyChart({required String nop});
}
