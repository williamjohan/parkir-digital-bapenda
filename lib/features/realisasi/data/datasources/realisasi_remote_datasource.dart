import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/exception.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/dio_error_handler.dart';
import '../models/realisasi_model.dart';

abstract class RealisasiRemoteDataSource {
  Future<List<RealisasiModel>> getRealisasiSeluruhOp(int tahun);
}

@LazySingleton(as: RealisasiRemoteDataSource)
class RealisasiRemoteDataSourceImpl implements RealisasiRemoteDataSource {
  final Dio _dio;

  RealisasiRemoteDataSourceImpl(this._dio);

  @override
  Future<List<RealisasiModel>> getRealisasiSeluruhOp(int tahun) async {
    try {
      AppLogger.info('Request Realisasi Seluruh OP Tahun: $tahun');

      final response = await _dio.get(
        ApiEndpoints.summaryRealisasiDev,
        queryParameters: {'tahun': tahun},
      );

      final responseData = response.data;

      AppLogger.info('Response Realisasi Seluruh OP: $responseData');

      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        final List data = responseData['data'] ?? [];
        return data.map((json) => RealisasiModel.fromJson(json)).toList();
      }

      throw ServerException(
        statusCode: responseData['statusCode'] ?? 500,
        message:
            responseData['message'] ??
            'Terjadi kesalahan saat mengambil data realisasi',
      );
    } on DioException catch (e) {
      AppLogger.error(
        '>>> [DIO ERROR REALISASI SELURUH OP] ${e.response?.data}',
      );

      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Get Realisasi Seluruh OP', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses data realisasi',
      );
    }
  }
}
