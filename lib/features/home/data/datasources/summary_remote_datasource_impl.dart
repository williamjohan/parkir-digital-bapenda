import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../models/dashboard_summary_model.dart';
import '../models/weekly_chart_item_model.dart';
import 'i_summary_remote_datasource.dart';

@LazySingleton(as: ISummaryRemoteDataSource)
class SummaryRemoteDataSourceImpl implements ISummaryRemoteDataSource {
  final Dio _dio;

  SummaryRemoteDataSourceImpl(this._dio);

  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    try {
      final response = await _dio.get('/api/mobile/parking/dashboard-summary');

      if (response.data['isSuccess'] == true) {
        return DashboardSummaryModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message:
              response.data['message'] ?? 'Gagal mengambil summary dashboard',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Terjadi kesalahan koneksi saat memuat dashboard',
      );
    } catch (e) {
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<WeeklyChartItemModel>> getWeeklyChart() async {
    try {
      final response = await _dio.get('/api/mobile/parking/weekly-chart');

      if (response.data['isSuccess'] == true) {
        final List<dynamic> dataList = response.data['data'];
        return dataList
            .map((json) => WeeklyChartItemModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message: response.data['message'] ?? 'Gagal mengambil data grafik',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Terjadi kesalahan koneksi saat memuat grafik',
      );
    } catch (e) {
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }
}
