import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/network/api_endpoints.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/dio_error_handler.dart';

abstract class IPaymentRemoteDataSource {
  Future<Map<String, dynamic>> generateQris({required double amount});

  Future<Map<String, dynamic>> checkQrisCallback({required String kodeQris});
}

@LazySingleton(as: IPaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl implements IPaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> generateQris({required double amount}) async {
    try {
      final formData = FormData.fromMap({"amount": amount.toInt()});

      final response = await _dio.post(
        ApiEndpoints.generateQris,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.data['isSuccess'] == true) {
        return response.data['data'];
      } else {
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message: response.data['message'] ?? 'Gagal generate QRIS',
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    } catch (e) {
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> checkQrisCallback({
    required String kodeQris,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.callBack,
        data: {"kodeQris": kodeQris},
      );

      if (response.data['isSuccess'] == true) {
        return response.data['data'];
      } else {
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message: response.data['message'] ?? 'Gagal mengecek status QRIS',
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    } catch (e) {
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan pengecekan: $e',
      );
    }
  }
}
