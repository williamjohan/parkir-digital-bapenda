import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/profile_photo_response_model.dart';

abstract class IProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<ProfilePhotoResponseModel> getProfilePhoto();
}

@LazySingleton(as: IProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements IProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> getProfile() async {
    try {
      AppLogger.info(
        ">>> [Profile DS] Memulai request ke: ${ApiEndpoints.profileDev}",
      );

      final response = await _dio.get(ApiEndpoints.profileDev);
      final responseData = response.data;

      AppLogger.info(">>> [Profile DS] Raw Response: $responseData");

      if (responseData['isSuccess'] == true) {
        final beData = responseData['data'];

        try {
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
          throw const ServerException(
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

  @override
  Future<ProfilePhotoResponseModel> getProfilePhoto() async {
    try {
      AppLogger.info('>>> [GET FOTO PROFIL] Memulai request...');

      final response = await _dio.get(ApiEndpoints.profilePhoto);

      final responseData = response.data;

      // 🛡️ SECURITY & INTEGRITY CHECK
      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        // Log disamarkan agar terminal tidak lag karena base64 yang sangat panjang
        AppLogger.info('>>> [GET FOTO PROFIL] Sukses! Menerima data Base64.');

        // Kembalikan dalam bentuk Model
        return ProfilePhotoResponseModel.fromJson(responseData['data'] ?? {});
      }

      throw ServerException(
        statusCode: responseData['statusCode'] ?? 500,
        message:
            responseData['message'] ??
            'Terjadi kesalahan saat memuat foto profil',
      );
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR GET FOTO PROFIL] ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('>>> [INTERNAL ERROR GET FOTO PROFIL]', e, stackTrace);
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses foto profil',
      );
    }
  }
}
