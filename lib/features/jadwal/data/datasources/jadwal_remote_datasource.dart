import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../../core/utils/app_logger.dart';
import '../model/jadwal_model.dart';

abstract class IJadwalRemoteDataSource {
  Future<List<JadwalModel>> getJadwalInfo();
}

@LazySingleton(as: IJadwalRemoteDataSource)
class JadwalRemoteDataSourceImpl implements IJadwalRemoteDataSource {
  final Dio _dio;

  JadwalRemoteDataSourceImpl(this._dio);

  @override
  Future<List<JadwalModel>> getJadwalInfo() async {
    try {
      AppLogger.info(
        ">>> [Jadwal DS] Memulai request ke: ${ApiEndpoints.jadwalPengawasDev}",
      );

      final response = await _dio.get(ApiEndpoints.jadwalPengawasDev);
      final responseData = response.data;

      AppLogger.info(">>> [Jadwal DS] Raw Response: $responseData");

      if (responseData['isSuccess'] == true) {
        final List<dynamic> beData = responseData['data'];

        try {
          AppLogger.info(
            ">>> [Jadwal DS] Mencoba parsing JSON ke JadwalModel...",
          );
          final List<JadwalModel> listModel = beData
              .map(
                (dynamic item) =>
                    JadwalModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
          AppLogger.info(">>> [Jadwal DS] Parsing BERHASIL!");
          return listModel;
        } catch (parseError, stackTrace) {
          AppLogger.error(
            ">>> [Jadwal DS] FATAL ERROR: Gagal mapping JSON ke JadwalModel!",
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
}
