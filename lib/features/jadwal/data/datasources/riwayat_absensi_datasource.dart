import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/jadwal/data/model/riwayat_absensi_model.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../../core/utils/app_logger.dart';

abstract class IRiwayatAbsensiDataSource {
  Future<List<RiwayatAbsensiModel>> getRiwayatAbsensiInfo({
    required DateTime tglAwal,
    required DateTime tglAkhir,
  });
}

@LazySingleton(as: IRiwayatAbsensiDataSource)
class RiwayatAbsensiDataSourceImpl implements IRiwayatAbsensiDataSource {
  final Dio _dio;

  RiwayatAbsensiDataSourceImpl(this._dio);

  @override
  Future<List<RiwayatAbsensiModel>> getRiwayatAbsensiInfo({
    required DateTime tglAwal,
    required DateTime tglAkhir,
  }) async {
    try {
      AppLogger.info(
        ">>> [Jadwal DS] Memulai request ke: ${ApiEndpoints.riwayatPengawasanSp3}",
      );

      final response = await _dio.get(
        ApiEndpoints.riwayatPengawasanSp3,
        queryParameters: {
          'tglAwal': _formatDate(tglAwal),
          'tglAkhir': _formatDate(tglAkhir),
        },
      );
      final responseData = response.data;

      AppLogger.info(">>> [Jadwal DS] Raw Response: $responseData");

      if (responseData['isSuccess'] == true) {
        final List<dynamic> beData = responseData['data'];

        try {
          AppLogger.info(
            ">>> [Jadwal DS] Mencoba parsing JSON ke RiwayatAbsensiModel...",
          );
          final listModel = beData
              .map(
                (dynamic item) => RiwayatAbsensiModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
          AppLogger.info(">>> [Jadwal DS] Parsing BERHASIL!");
          return listModel;
        } catch (parseError, stackTrace) {
          AppLogger.error(
            ">>> [Jadwal DS] FATAL ERROR: Gagal mapping JSON ke RiwayatAbsensiModel!",
            parseError,
            stackTrace,
          );
          throw const ServerException(
            statusCode: 500,
            message:
                'Struktur data jadwal dari server tidak sesuai format aplikasi.',
          );
        }
      } else {
        AppLogger.error(">>> [Jadwal DS] Envelope isSuccess = false");
        throw ServerException(
          statusCode: response.statusCode ?? 500,
          message: responseData['message'] ?? 'Gagal memuat data jadwal.',
        );
      }
    } on DioException catch (e) {
      AppLogger.error(
        ">>> [Jadwal DS] DIO ERROR: ${e.response?.statusCode} - ${e.message}",
        e,
        null,
      );
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error(
        '>>> [Jadwal DS] Internal Error Tidak Terduga',
        e,
        stackTrace,
      );
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses jadwal.',
      );
    }
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
