import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/network/api_endpoints.dart';
import 'package:parkir_digital_bapenda/core/network/dio_error_handler.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/history_item_model.dart';

abstract class ITransactionHistoryRemoteDataSource {
  Future<List<HistoryItemModel>> getHistory({
    required String nop,
    required int petugasId,
    required String shift,
    required DateTime startDate,
    required DateTime endDate,
    int? limit,
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
    int? limit,
  }) async {
    final sDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      0,
      0,
      0,
    );
    final eDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
    );

    final String startIso = "${sDate.toIso8601String().substring(0, 23)}Z";
    final String endIso = "${eDate.toIso8601String().substring(0, 23)}Z";

    final formData = FormData.fromMap({
      'nop': nop,
      'petugasId': petugasId.toString(),
      'shift': shift,
      'tglAwal': startIso,
      'tglAkhir': endIso,
      'limit': limit?.toString() ?? '',
    });

    // ==========================================================
    // 🔍 [LOG X-RAY] CEK PAYLOAD HISTORY
    // ==========================================================
    AppLogger.debug('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓');
    AppLogger.debug('┃ 🔍 MENGIRIM GET HISTORY KE /laporan-pendapatan');
    AppLogger.debug('┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫');
    for (var field in formData.fields) {
      AppLogger.debug('┃ 🔑 ${field.key} : ${field.value}');
    }
    AppLogger.debug('┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛');
    // ==========================================================

    try {
      final response = await _dio.post(
        ApiEndpoints.laporanPendapatan,
        data: formData,
      );

      final responseData = response.data;
      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        final List<dynamic> dataList = responseData['data'] ?? [];
        return dataList.map((json) => HistoryItemModel.fromJson(json)).toList();
      } else {
        throw Exception(responseData['message'] ?? 'Gagal mengambil riwayat');
      }
    } on DioException catch (e) {
      AppLogger.error('>>> [DEBUG 500] Response: ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error di History', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses data riwayat.',
      );
    }
  }
}
