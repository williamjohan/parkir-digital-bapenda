import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/qris/qris_model.dart';

abstract class IQrisRemoteDataSource {
  Future<List<QrisResponseModel>> getQrisRompi();
  Future<String> getQrisLastUpdate();
}

@LazySingleton(as: IQrisRemoteDataSource)
class QrisRemoteDataSourceImpl implements IQrisRemoteDataSource {
  final Dio _dio;

  QrisRemoteDataSourceImpl(this._dio);

  @override
  Future<List<QrisResponseModel>> getQrisRompi() async {
    try {
      AppLogger.info(
        ">>> [Qris DS] Memulai request ke: ${ApiEndpoints.qrisRompiDev}",
      );

      final response = await _dio.get(ApiEndpoints.qrisRompiDev);
      final responseData = response.data;

      AppLogger.info(">>> [Qris DS] Raw Response: $responseData");

      if (responseData['isSuccess'] == true) {
        final List<dynamic> dataList = responseData['data'] ?? [];

        try {
          AppLogger.info(
            ">>> [Qris DS] Mencoba parsing JSON ke List<QrisResponseModel>...",
          );

          final result = dataList
              .map(
                (json) =>
                    QrisResponseModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          AppLogger.info(">>> [Qris DS] Parsing BERHASIL!");
          return result;
        } catch (parseError, stackTrace) {
          AppLogger.error(
            ">>> [Qris DS] FATAL ERROR: Gagal mapping JSON ke QrisResponseModel!",
            parseError,
            stackTrace,
          );
          throw const ServerException(
            statusCode: 500,
            message:
                'Struktur data QRIS dari server tidak sesuai format aplikasi.',
          );
        }
      } else {
        AppLogger.error(">>> [Qris DS] Envelope isSuccess = false");
        throw ServerException(
          statusCode: response.statusCode ?? 500,
          message: responseData['message'] ?? 'Gagal memuat data QRIS.',
        );
      }
    } on DioException catch (e) {
      AppLogger.error(
        ">>> [Qris DS] DIO ERROR: ${e.response?.statusCode} - ${e.message}",
        e,
        null,
      );
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error(
        '>>> [Qris DS] Internal Error Tidak Terduga',
        e,
        stackTrace,
      );
      if (e is ServerException) {
        rethrow;
      }
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses QRIS.',
      );
    }
  }

  @override
  Future<String> getQrisLastUpdate() async {
    try {
      AppLogger.info(
        ">>> [Qris DS] Memulai request cek versi ke: ${ApiEndpoints.qrisCheckVersionDev}",
      );

      final response = await _dio.get(ApiEndpoints.qrisCheckVersionDev);
      final responseData = response.data;

      AppLogger.info(">>> [Qris DS] Raw Response: $responseData");

      if (responseData['isSuccess'] == true) {
        try {
          AppLogger.info(
            ">>> [Qris DS] Mencoba mengekstrak data lastUpdate...",
          );

          final lastUpdate = responseData['data'] as String?;

          if (lastUpdate != null && lastUpdate.isNotEmpty) {
            AppLogger.info(">>> [Qris DS] Ekstraksi BERHASIL: $lastUpdate");
            return lastUpdate;
          } else {
            throw Exception('Data string versi kosong atau null');
          }
        } catch (parseError, stackTrace) {
          AppLogger.error(
            ">>> [Qris DS] FATAL ERROR: Gagal membaca format tanggal update dari server!",
            parseError,
            stackTrace,
          );
          throw const ServerException(
            statusCode: 500,
            message: 'Struktur data versi QRIS dari server tidak valid.',
          );
        }
      } else {
        AppLogger.error(
          ">>> [Qris DS] Envelope isSuccess = false pada cek versi",
        );
        throw ServerException(
          statusCode: response.statusCode ?? 500,
          message: responseData['message'] ?? 'Gagal mengecek versi data QRIS.',
        );
      }
    } on DioException catch (e) {
      AppLogger.error(
        ">>> [Qris DS] DIO ERROR: ${e.response?.statusCode} - ${e.message}",
        e,
        null,
      );
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error(
        '>>> [Qris DS] Internal Error Tidak Terduga saat cek versi',
        e,
        stackTrace,
      );
      if (e is ServerException) {
        rethrow;
      }
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat mengecek update QRIS.',
      );
    }
  }
}
