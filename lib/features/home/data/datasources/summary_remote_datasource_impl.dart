import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/network/api_endpoints.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../../core/utils/app_logger.dart';
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
      final response = await _dio.get(ApiEndpoints.dashboardSummary);

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
      final response = await _dio.get(ApiEndpoints.weeklyChart);

      // ==========================================================
      // 🔍 [LOG X-RAY] RESPONSE WEEKLY CHART
      // ==========================================================
      AppLogger.debug('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓');
      AppLogger.debug('┃ 📥 RESPONSE WEEKLY CHART');
      AppLogger.debug('┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫');
      AppLogger.debug('┃ ✅ STATUS CODE : ${response.statusCode}');
      AppLogger.debug('┃ 📦 RAW DATA : ${response.data}');
      AppLogger.debug('┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛');

      if (response.data['isSuccess'] == true) {
        final List<dynamic> dataList = response.data['data'];

        // ==========================================================
        // 🔍 [LOG X-RAY] PARSED DATA
        // ==========================================================
        AppLogger.debug('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓');
        AppLogger.debug('┃ 📊 PARSED WEEKLY CHART');
        AppLogger.debug('┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫');
        AppLogger.debug('┃ 📈 TOTAL DATA : ${dataList.length}');
        for (var i = 0; i < dataList.length; i++) {
          AppLogger.debug('┃ 📌 ITEM[$i] : ${dataList[i]}');
        }
        AppLogger.debug('┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛');
        // ==========================================================

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
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error di Summary', e, stackTrace);
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses summary}',
      );
    }
  }
}
