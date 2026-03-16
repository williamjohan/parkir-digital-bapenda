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
  final Dio
  _dio; // Ingat, ini dio dari DioClient yang sudah ada AuthInterceptor-nya

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      final responseData = response.data;

      // 1. Cek Envelope Bapenda
      if (responseData['isSuccess'] == true) {
        final beData = responseData['data'];

        // 2. THE ADAPTER: Kita konversi JSON flat dari BE menjadi JSON nested untuk FE
        final mappedJson = {
          'accessToken': beData['accessToken'] ?? '',
          'refreshToken': beData['refreshToken'] ?? '',
          'user': {
            // Jika saat di-test BE belum siap dengan field ini,
            // fallback (?? '') akan mengamankan aplikasi agar tidak crash!
            'idUser': beData['idJukir'] ?? '',
            'namaUser': beData['namaUser'] ?? '',
            'nop': beData['nop'] ?? '',
            // Siapkan slot kosong untuk data yang baru akan didapat nanti di /profile
            'namaObjekPajak': '',
            'alamat': '',
          },
        };

        // 3. Masukkan ke Model andalan Anda
        return AuthResponseModel.fromJson(mappedJson);
      } else {
        // Jika isSuccess false dari BE
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
