// lib/features/auth/data/datasources/auth_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/auth_response_model.dart';

abstract class IAuthRemoteDataSource {
  Future<AuthResponseModel> login(String username, String password);
}

@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      final responseData = response.data;

      if (responseData['isSuccess'] == true) {
        final beData = responseData['data'];

        // [PERBAIKAN]: Konversi secara eksplisit ke String/Int untuk mencegah tabrakan tipe
        final mappedJson = {
          'accessToken': beData['accessToken']?.toString() ?? '',
          'refreshToken': beData['refreshToken']?.toString() ?? '',
          'user': {
            'idUser':
                beData['idJukir'] ??
                0, // Biarkan utuh, Model yang akan merapikannya
            'namaUser': beData['namaUser'] ?? '',
            'nop': beData['nop'] ?? '',
            'namaObjekPajak': '',
            'alamat': '',
            'pungutTarif': 0, // Beri default aman
            'lokasiId': 0, // Beri default aman
          },
        };

        return AuthResponseModel.fromJson(mappedJson);
      } else {
        throw AuthException(
          message:
              responseData['message'] ??
              'Login gagal, periksa kredensial Anda.',
        );
      }
    } on DioException catch (e) {
      final int statusCode = e.response?.statusCode ?? 500;
      final String? backendMessage = e.response?.data?['message'];

      if (statusCode == 401 || statusCode == 404 || statusCode == 400) {
        throw AuthException(
          message: backendMessage ?? 'Username atau password Jukir salah.',
        );
      }

      throw ServerException(
        statusCode: statusCode,
        message:
            backendMessage ?? e.message ?? 'Gagal terhubung ke server Bapenda.',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal aplikasi.',
      );
    }
  }
}
