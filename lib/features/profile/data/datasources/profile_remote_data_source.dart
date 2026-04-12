// lib/features/auth/data/datasources/profile_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../auth/data/models/user_model.dart'; // Sesuaikan path jika berbeda

abstract class IProfileRemoteDataSource {
  Future<UserModel> getProfile();
}

@LazySingleton(as: IProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements IProfileRemoteDataSource {
  final Dio _dio; // Dio ini otomatis sudah membawa Token dari AuthInterceptor!

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> getProfile() async {
    try {
      // 1. Tembak endpoint Profile (Pastikan Anda sudah menambahkan ApiEndpoints.profile)
      final response = await _dio.get(ApiEndpoints.profile);

      final responseData = response.data;

      // 2. Cek Envelope Bapenda
      if (responseData['isSuccess'] == true) {
        final beData = responseData['data'];

        // 3. MAGIC HAPPENS HERE: Langsung konversi! Tidak perlu manual mapping (Adapter)
        // karena nama property di UserModel sudah sama persis dengan JSON BE.
        return UserModel.fromJson(beData);
      } else {
        throw ServerException(
          statusCode: response.statusCode ?? 500,
          message: responseData['message'] ?? 'Gagal memuat data profil.',
        );
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    } catch (e) {
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memparsing profil.',
      );
    }
  }
}
