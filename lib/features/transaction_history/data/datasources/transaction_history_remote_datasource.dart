import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/network/api_endpoints.dart';
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
    // 🚀 [STRATEGI AMAN]: Set jam ke 12:00 agar saat .toUtc() tidak lompat ke hari kemarin
    final sDate = DateTime(startDate.year, startDate.month, startDate.day, 12);
    final eDate = DateTime(endDate.year, endDate.month, endDate.day, 12);

    // 🚀 [STANDAR SWAGGER]: Ambil 23 karakter (milidetik) + Z
    final String startIso =
        "${sDate.toUtc().toIso8601String().substring(0, 23)}Z";
    final String endIso =
        "${eDate.toUtc().toIso8601String().substring(0, 23)}Z";

    final formData = FormData.fromMap({
      'nop': nop,
      'petugasId': petugasId
          .toString(), // Pastikan String sesuai praktik aman BE
      'shift': shift,
      'tglAwal': startIso,
      'tglAkhir': endIso,
      if (limit != null) 'limit': limit.toString(),
    });

    try {
      final response = await _dio.post(
        ApiEndpoints.laporanPendapatan,
        data: formData,
        // 🚀 [BYPASS RETRY]: Mencoba mematikan retry khusus hit ini
        options: Options(
          extra: {
            'no_retry': true, // Key umum untuk dio_smart_retry
            'ro_attempt': 0, // Paksa attempt ke 0
          },
        ),
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
      // 🚀 Sekarang error 500 akan langsung tertangkap di sini tanpa nunggu retry
      AppLogger.error('>>> [DEBUG 500] Response: ${e.response?.data}');
      throw Exception(
        e.response?.data?['message'] ?? 'Terjadi kesalahan server.',
      );
    }
  }
}
