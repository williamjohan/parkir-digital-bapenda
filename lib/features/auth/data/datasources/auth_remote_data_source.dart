import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../../core/storage/i_secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/device_id_utils.dart';
import '../models/auth_response_model.dart';

abstract class IAuthRemoteDataSource {
  Future<AuthResponseModel> login(String username, String password);
  Future<bool> checkDeviceUuid();
  Future<String> getKantorkuSsoUrl();
  Future<AuthResponseModel> loginWithKantorkuSession(String sessionId);
}

@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final Dio _dio;
  final ISecureStorageManager _secureStorage;

  AuthRemoteDataSourceImpl(this._dio, this._secureStorage);

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final deviceId = await DeviceIdUtils.getSecureDeviceId(_secureStorage);

      final response = await _dio.post(
        ApiEndpoints.loginDev,
        data: {
          'username': username,
          'password': password,
          "uuidPerangkat": deviceId,
        },
      );

      debugPrint("deviceId : $deviceId");

      final responseData = response.data;

      if (responseData['isSuccess'] == true) {
        final beData = responseData['data'];

        // final mappedJson = {
        //   'accessToken': beData['accessToken']?.toString() ?? '',
        //   'refreshToken': beData['refreshToken']?.toString() ?? '',
        //   'nop': beData['nop']?.toString() ?? '',
        //   'uuidStatic': beData['uuidStatic']?.toString() ?? '',
        //   'roleLoginId': beData['roleLoginId'] ?? 0,
        //   'nopList': beData['nopList'] ?? [],
        //   'user': {
        //     'idUser': beData['idJukir'] ?? 0,
        //     'namaUser': beData['namaUser'] ?? '',
        //     'nop': beData['nop'] ?? '',
        //     'namaObjekPajak': '',
        //     'alamat': '',
        //     'pungutTarif': 0,
        //     'lokasiId': 0,
        //   },
        // };

        return AuthResponseModel.fromJson(beData);
      } else {
        throw AuthException(
          message:
              responseData['message'] ??
              'Login gagal, periksa kredensial Anda.',
        );
      }
    } on DioException catch (e) {
      final int statusCode = e.response?.statusCode ?? 500;
      if (statusCode == 401 || statusCode == 404 || statusCode == 400) {
        final String? backendMessage = e.response?.data?['message'];
        throw AuthException(
          message: backendMessage ?? 'Username atau password Jukir salah.',
        );
      }
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      if (e is AuthException) rethrow;
      AppLogger.error('Internal Error di AuthRemoteDataSource', e, stackTrace);
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal aplikasi.',
      );
    }
  }

  @override
  Future<bool> checkDeviceUuid() async {
    final deviceId = await DeviceIdUtils.getSecureDeviceId(_secureStorage);

    AppLogger.debug("device id : $deviceId");

    final response = await _dio.post(
      ApiEndpoints.cekUuidDev,
      data: {'uuidPerangkat': deviceId},
    );

    return response.data['data']['isUuidPerangkat'] == true;
  }

  @override
  Future<String> getKantorkuSsoUrl() async {
    try {
      // 1. Hit endpoint authorize-login-kominfo
      final response = await _dio.get(ApiEndpoints.kantorkuUrl);

      if (response.data['success'] == true) {
        final data = response.data['data'];

        final baseUrl = data['url'];
        final clientId = data['clientId'];
        final redirectUri = data['redirectUri'];
        final responseType = data['responseType'];

        // 2. Concat (Rangkai) URL berdasarkan parameter respons
        final ssoUrl =
            '$baseUrl?client_id=$clientId&redirect_uri=$redirectUri&response_type=$responseType&scope=';

        return ssoUrl;
      } else {
        throw ServerException(
          statusCode: 500,
          message: response.data['message'] ?? 'Gagal memuat URL SSO',
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error di getKantorkuSsoUrl', e, stackTrace);
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResponseModel> loginWithKantorkuSession(String sessionId) async {
    try {
      AppLogger.debug("Menukarkan Session ID ke Backend: $sessionId");

      // Menembak endpoint baru menggunakan query parameter session
      final response = await _dio.get(
        ApiEndpoints.loginWithKantorkuSession,
        queryParameters: {'session': sessionId},
      );

      final responseData = response.data;

      // Asumsi: Struktur balasan dari BE sama persis dengan login() reguler
      if (responseData['isSuccess'] == true || responseData['status'] == true) {
        final beData = responseData['data'] ?? responseData;
        return AuthResponseModel.fromJson(beData);
      } else {
        throw AuthException(
          message:
              responseData['message'] ?? 'Gagal memvalidasi sesi SSO Kantorku.',
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Internal Error di loginWithKantorkuSession',
        e,
        stackTrace,
      );
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat penukaran sesi.',
      );
    }
  }
}
