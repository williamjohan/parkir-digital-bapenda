import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../models/data_jukir/data_jukir_model.dart';

abstract class DataJukirDatasource {
  Future<List<DataJukirModel>> getDataJukir(String nop);
}

@LazySingleton(as: DataJukirDatasource)
class DataJukirDatasourceImpl implements DataJukirDatasource {
  final Dio _dio;

  DataJukirDatasourceImpl(this._dio);

  @override
  Future<List<DataJukirModel>> getDataJukir(String nop) async {
    try {
      AppLogger.info('Request Data Jukir NOP: $nop');

      final response = await _dio.get(
        ApiEndpoints.dataJukirDev,
        queryParameters: {'nop': nop},
      );

      final responseData = response.data;

      AppLogger.info('Response Data Jukir: $responseData');

      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        final result = (responseData['data'] as List)
            .map((e) => DataJukirModel.fromJson(e))
            .toList();

        AppLogger.info('Berhasil mendapatkan data jukir');

        return result;
      }
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses data jukir}',
      );
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR] ${e.response?.data}');

      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Get Data Jukir', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses data jukir}',
      );
    }
  }
}
