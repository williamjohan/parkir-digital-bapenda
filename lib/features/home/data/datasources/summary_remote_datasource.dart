import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/network/api_endpoints.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/dashboard_summary_model.dart';
import '../models/dashboard_summary_non_jukir/dashboard_summary_non_jukir_model.dart';
import '../models/weekly_chart_item_model.dart';

abstract class ISummaryRemoteDataSource {
  Future<DashboardSummaryModel> getDashboardSummary({required String nop});

  Future<DashboardSummaryNonJukirModel> getDashboardSummaryNonJukir();

  Future<List<WeeklyChartItemModel>> getWeeklyChart({required String nop});
}

@LazySingleton(as: ISummaryRemoteDataSource)
class SummaryRemoteDataSourceImpl implements ISummaryRemoteDataSource {
  final Dio _dio;

  SummaryRemoteDataSourceImpl(this._dio);

  @override
  Future<DashboardSummaryModel> getDashboardSummary({
    required String nop,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.dashboardSummaryDev,
        queryParameters: {'nop': nop},
      );

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
  Future<DashboardSummaryNonJukirModel> getDashboardSummaryNonJukir() async {
    try {
      final response = await _dio.get(ApiEndpoints.dashboardSummaryNonJukirDev);

      if (response.data['isSuccess'] == true) {
        return DashboardSummaryNonJukirModel.fromJson(response.data['data']);
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
  Future<List<WeeklyChartItemModel>> getWeeklyChart({
    required String nop,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.weeklyChartDev,
        queryParameters: {'nop': nop},
      );

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
