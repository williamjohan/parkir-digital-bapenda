// lib/features/auth/data/datasources/profile_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../auth/data/models/user_model.dart';

abstract class IProfileRemoteDataSource {
  Future<UserModel> getProfile();
}

@LazySingleton(as: IProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements IProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> getProfile() async {
    try {
      AppLogger.info(
        ">>> [Profile DS] Memulai request ke: ${ApiEndpoints.profile}",
      );

      final response = await _dio.get(ApiEndpoints.profile);
      final responseData = response.data;

      AppLogger.info(">>> [Profile DS] Raw Response: $responseData");

      if (responseData['isSuccess'] == true) {
        final beData = responseData['data'];

        try {
          // 🚀 PASANG CCTV PARSING: Jika mati di sini, berarti UserModel tidak cocok dengan JSON Bapenda!
          AppLogger.info(
            ">>> [Profile DS] Mencoba parsing JSON ke UserModel...",
          );
          final userModel = UserModel.fromJson(beData);
          AppLogger.info(">>> [Profile DS] Parsing BERHASIL!");
          return userModel;
        } catch (parseError, stackTrace) {
          AppLogger.error(
            ">>> [Profile DS] FATAL ERROR: Gagal mapping JSON ke UserModel!",
            parseError,
            stackTrace,
          );
          throw ServerException(
            statusCode: 500,
            message:
                'Struktur data profil dari server tidak sesuai format aplikasi.',
          );
        }
      } else {
        AppLogger.error(">>> [Profile DS] Envelope isSuccess = false");
        throw ServerException(
          statusCode: response.statusCode ?? 500,
          message: responseData['message'] ?? 'Gagal memuat data profil.',
        );
      }
    } on DioException catch (e) {
      // 🚀 CCTV NETWORK: Menangkap murni penolakan server (misal 401 atau 404)
      AppLogger.error(
        ">>> [Profile DS] DIO ERROR: ${e.response?.statusCode} - ${e.message}",
        e,
        null,
      );
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error(
        '>>> [Profile DS] Internal Error Tidak Terduga',
        e,
        stackTrace,
      );
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses profil.',
      );
    }
  }
}
