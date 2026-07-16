import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/exception.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/dio_error_handler.dart';
import '../../../../../core/utils/app_logger.dart';
import '../model/detail_tax_surveillance_op_model.dart';

abstract class ITaxSurveillanceRemoteDataSource {
  Future<List<TaxSurveillanceDetailResponseModel>> getDefaultDetail(String nop);

  Future<List<TaxSurveillanceDetailResponseModel>> getFilteredDetail(
    TaxSurveillanceDetailRequestModel request,
  );
}

@LazySingleton(as: ITaxSurveillanceRemoteDataSource)
class TaxSurveillanceRemoteDataSourceImpl
    implements ITaxSurveillanceRemoteDataSource {
  final Dio _dio;

  TaxSurveillanceRemoteDataSourceImpl(this._dio);

  @override
  Future<List<TaxSurveillanceDetailResponseModel>> getDefaultDetail(
    String nop,
  ) async {
    AppLogger.debug('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓');
    AppLogger.debug('┃ 🔍 [GET] TAX SURVEILLANCE DEFAULT HARI INI');
    AppLogger.debug('┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫');
    AppLogger.debug('┃ 🔑 NOP : $nop');
    AppLogger.debug('┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛');

    try {
      final response = await _dio.get(
        ApiEndpoints.taxSurveillanceDetail,
        queryParameters: {'nop': nop},
      );

      return _parseResponse(response.data);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Internal Error GET Default Tax Surveillance',
        e,
        stackTrace,
      );
      throw const ServerException(
        statusCode: 500,
        message: 'Gagal memproses data default surveillance.',
      );
    }
  }

  @override
  Future<List<TaxSurveillanceDetailResponseModel>> getFilteredDetail(
    TaxSurveillanceDetailRequestModel request,
  ) async {
    AppLogger.debug('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓');
    AppLogger.debug('┃ 🔍 [POST] TAX SURVEILLANCE FILTER BY DATE');
    AppLogger.debug('┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫');
    AppLogger.debug('┃ 📦 Payload : ${request.toJson()}');
    AppLogger.debug('┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛');

    try {
      final response = await _dio.post(
        ApiEndpoints.taxSurveillanceDetail,
        data: request.toJson(),
      );

      return _parseResponse(response.data);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Internal Error POST Filter Tax Surveillance',
        e,
        stackTrace,
      );
      throw const ServerException(
        statusCode: 500,
        message: 'Gagal memproses riwayat filter surveillance.',
      );
    }
  }

  /// Helper internal agar parsing JSON tidak duplikat di antara GET dan POST
  List<TaxSurveillanceDetailResponseModel> _parseResponse(
    dynamic responseData,
  ) {
    if (responseData['isSuccess'] == true &&
        responseData['statusCode'] == 200) {
      final List data = responseData['data'] ?? [];
      return data
          .map((e) => TaxSurveillanceDetailResponseModel.fromJson(e))
          .toList();
    } else {
      throw Exception(
        responseData['message'] ?? 'Gagal mengambil data surveillance',
      );
    }
  }
}
