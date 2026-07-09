import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/errors/exception.dart';
import '../../../../../../core/utils/app_logger.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/dio_error_handler.dart';
import '../models/dashboard_op_response_model.dart';

abstract class DashboardOpDatasource {
  Future<DashboardOpResponseModel> getSummaryDashboardOp(String nop);
}

@LazySingleton(as: DashboardOpDatasource)
class DashboardOpDatasourceImpl implements DashboardOpDatasource {
  final Dio _dio;

  DashboardOpDatasourceImpl(this._dio);

  @override
  Future<DashboardOpResponseModel> getSummaryDashboardOp(String nop) async {
    try {
      AppLogger.info('Request Summary Dashboard OP NOP: $nop');

      final response = await _dio.get(
        ApiEndpoints.summaryOpDev,
        queryParameters: {'nop': nop},
      );

      final responseData = response.data;

      AppLogger.info('Response Summary Dashboard OP: $responseData');

      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        final result = DashboardOpResponseModel.fromJson(responseData['data']);

        AppLogger.info('Berhasil mendapatkan summary dashboard OP');

        return result;
      }

      throw ServerException(
        statusCode: responseData['statusCode'] ?? 500,
        message:
            responseData['message'] ??
            'Terjadi kesalahan saat memproses summary dashboard OP',
      );
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR] ${e.response?.data}');

      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Get Summary Dashboard OP', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message:
            'Terjadi kesalahan internal saat memproses summary dashboard OP',
      );
    }
  }
}
