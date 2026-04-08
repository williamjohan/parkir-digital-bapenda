import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class IPaymentRemoteDataSource {
  Future<Map<String, dynamic>> requestQrisData({
    required String nop,
    required int nominal,
  });
}

@LazySingleton(as: IPaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl implements IPaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> requestQrisData({
    required String nop,
    required int nominal,
  }) async {
    // 🔥 1. WAJIB pakai FormData
    final formData = FormData.fromMap({
      'nop': nop,
      'amount': nominal, // ⚠️ bukan nominal!
    });

    try {
      AppLogger.debug('>>> [QRIS] Request generate QRIS:');
      AppLogger.debug('nop: $nop');
      AppLogger.debug('amount: $nominal');

      // 🔥 2. HIT API
      final response = await _dio.post(
        ApiEndpoints.generateQris,
        data: formData,
      );

      final responseData = response.data;

      // 🔥 3. VALIDASI (ikut pattern senior)
      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        return responseData['data'];
      } else {
        throw Exception(responseData['message'] ?? 'Gagal generate QRIS');
      }
    } on DioException catch (e) {
      AppLogger.error('>>> [QRIS ERROR] DioException: ${e.message}');
      AppLogger.error('>>> [QRIS ERROR BODY]: ${e.response?.data}');

      throw Exception(
        e.response?.data?['message'] ?? 'Gagal terhubung ke server',
      );
    }
  }
}
