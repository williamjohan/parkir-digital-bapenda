// lib/features/auth/data/datasources/auth_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class IAuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
}

// @LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data'];
      } else {
        // Jika server mengembalikan status aneh tapi tidak masuk catch Dio
        throw ServerException(
          statusCode: response.statusCode ?? 500,
          message: 'Terjadi kesalahan pada server Bapenda.',
        );
      }
    } on DioException catch (e) {
      // 1. Amankan status code (jika null, anggap 500 Internal Server Error)
      final int statusCode = e.response?.statusCode ?? 500;

      // 2. Tangkap error spesifik 401/404 dari BE (Password / User Salah)
      if (statusCode == 401 || statusCode == 404) {
        throw const AuthException(
          message: 'Username atau password Jukir salah.',
        );
      }

      // 3. (Opsional tapi Best Practice) Coba tangkap pesan error asli dari JSON Backend Bapenda
      // Biasanya Backend mengirim format: {"message": "Email tidak ditemukan"}
      final String? backendMessage = e.response?.data?['message'];

      // 4. Lempar ServerException yang sudah diperkaya dengan statusCode
      throw ServerException(
        statusCode: statusCode,
        message: backendMessage ?? e.message ?? 'Gagal terhubung ke server.',
      );
    } catch (e) {
      // Tangkap error di luar Dio (misal kesalahan parsing JSON)
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal aplikasi.',
      );
    }
  }
}
