import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/exception.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../domain/entities/qris_rompi_request_entity.dart';
import '../mapper/qris_rompi_mapper.dart';

abstract class QrisRompiDatasource {
  Future<String> getQrisRompi(QrisRompiRequestEntity request);
}

@LazySingleton(as: QrisRompiDatasource)
class QrisRompiDatasourceImpl implements QrisRompiDatasource {
  final Dio _dio;

  QrisRompiDatasourceImpl(this._dio);

  @override
  Future<String> getQrisRompi(QrisRompiRequestEntity request) async {
    try {
      final payload = QrisRompiRequestMapper.toJson(request);

      AppLogger.info('Request QRIS Rompi: $payload');

      final response = await _dio.get(
        ApiEndpoints.qrisRompiDev,
        queryParameters: payload,
      );

      final responseData = response.data;

      AppLogger.info('Response QRIS Rompi: $responseData');

      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        return responseData['data'] ?? '';
      }
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses qris rompi jukir}',
      );
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR QRIS ROMPI] ${e.response?.data}');

      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Get QRIS Rompi', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses qris rompi jukir}',
      );
    }
  }
}
