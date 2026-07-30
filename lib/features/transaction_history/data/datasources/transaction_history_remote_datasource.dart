import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/network/api_endpoints.dart';
import 'package:parkir_digital_bapenda/core/network/dio_error_handler.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/sof_summary_model.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/history_response_data_model.dart';

abstract class ITransactionHistoryRemoteDataSource {
  Future<HistoryResponseData> getHistory({
    required String nop,
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
    required int jenisKendaraan,
    String? idDevice,
  });

  Future<List<SofSummaryModel>> getSofBreakdown({
    required String nop,
    required DateTime startDate,
    required DateTime endDate,
    required int jenisKendaraan,
  });
}

@LazySingleton(as: ITransactionHistoryRemoteDataSource)
class TransactionHistoryRemoteDataSourceImpl
    implements ITransactionHistoryRemoteDataSource {
  final Dio _dio;

  TransactionHistoryRemoteDataSourceImpl(this._dio);

  @override
  Future<HistoryResponseData> getHistory({
    required String nop,
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
    required int jenisKendaraan,
    String? idDevice,
  }) async {
    final String startIso =
        "${startDate.toUtc().toIso8601String().substring(0, 23)}Z";

    final String endIso =
        "${endDate.toUtc().toIso8601String().substring(0, 23)}Z";

    final formData = FormData.fromMap({
      'nop': nop,
      'tglAwal': startIso,
      'tglAkhir': endIso,
      'page': page,
      'pageSize': pageSize,
      'jenisKendaraan': jenisKendaraan,
      'idDevice': idDevice,
    });
    AppLogger.debug('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓');
    AppLogger.debug('┃ 🔍 MENGIRIM GET HISTORY KE /laporan-pendapatan');
    AppLogger.debug('┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫');
    for (var field in formData.fields) {
      AppLogger.debug('┃ 🔑 ${field.key} : ${field.value}');
    }
    AppLogger.debug('┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛');

    try {
      final response = await _dio.post(
        ApiEndpoints.laporanPendapatanDev,
        data: formData,
      );

      final responseData = response.data;
      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        final data = responseData['data'];

        return HistoryResponseData.fromJson(data);
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

  @override
  Future<List<SofSummaryModel>> getSofBreakdown({
    required String nop,
    required DateTime startDate,
    required DateTime endDate,
    required int jenisKendaraan,
  }) async {
    final String startIso =
        "${startDate.toUtc().toIso8601String().substring(0, 23)}Z";
    final String endIso =
        "${endDate.toUtc().toIso8601String().substring(0, 23)}Z";

    final formData = FormData.fromMap({
      'nop': nop,
      'tglAwal': startIso,
      'tglAkhir': endIso,
      'jenisKendaraan': jenisKendaraan,
    });

    AppLogger.debug('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓');
    AppLogger.debug('┃ 🔍 MENGIRIM GET SOF BREAKDOWN');
    AppLogger.debug('┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫');
    for (var field in formData.fields) {
      AppLogger.debug('┃ 🔑 ${field.key} : ${field.value}');
    }
    AppLogger.debug('┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛');

    try {
      final response = await _dio.post(
        ApiEndpoints.laporanPendapatanSof, 
        data: formData,
      );

      final responseData = response.data;
      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        final List data = responseData['data'] ?? [];
        return data.map((e) => SofSummaryModel.fromJson(e)).toList();
      } else {
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil data metode pembayaran',
        );
      }
    } on DioException catch (e) {
      AppLogger.error('>>> [DEBUG 500] Response: ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error di SOF Breakdown', e, stackTrace);
      throw const ServerException(
        statusCode: 500,
        message:
            'Terjadi kesalahan internal saat memproses data metode pembayaran.',
      );
    }
  }
}
