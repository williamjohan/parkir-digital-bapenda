import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/history_item_model.dart';

abstract class ITransactionHistoryRemoteDataSource {
  Future<List<HistoryItemModel>> getHistory({
    required String nop,
    required int petugasId,
    required String shift,
    required DateTime startDate,
    required DateTime endDate,
  });
}

@LazySingleton(as: ITransactionHistoryRemoteDataSource)
class TransactionHistoryRemoteDataSourceImpl
    implements ITransactionHistoryRemoteDataSource {
  final Dio _dio;

  TransactionHistoryRemoteDataSourceImpl(this._dio);

  @override
  Future<List<HistoryItemModel>> getHistory({
    required String nop,
    required int petugasId,
    required String shift,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // 1. Rakit FormData sesuai permintaan POST BE
    final formData = FormData.fromMap({
      'nop': nop,
      'petugasId': petugasId,
      'shift': shift,
      // Format ISO-8601 (Contoh: 2026-04-01T00:41:29.187Z)
      'tglAwal': startDate.toUtc().toIso8601String(),
      'tglAkhir': endDate.toUtc().toIso8601String(),
    });

    try {
      AppLogger.debug(
        '>>> [HISTORY] Mengambil data: ${startDate.toIso8601String()} sd ${endDate.toIso8601String()}',
      );

      // 2. Tembak API POST
      final response = await _dio.post(
        '/api/mobile/parking/laporan-pendapatan',
        data: formData,
      );

      final responseData = response.data;

      // 3. Validasi & Parsing Data
      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        final List<dynamic> dataList = responseData['data'] ?? [];

        return dataList.map((json) => HistoryItemModel.fromJson(json)).toList();
      } else {
        throw Exception(responseData['message'] ?? 'Gagal mengambil riwayat');
      }
    } on DioException catch (e) {
      AppLogger.error('>>> [HISTORY ERROR] DioException: ${e.message}');
      throw Exception(
        e.response?.data?['message'] ?? 'Gagal terhubung ke server',
      );
    }
  }
}
