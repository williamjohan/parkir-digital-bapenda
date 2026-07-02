import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/exception.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../models/absensi_model.dart';

abstract class IAbsensiRemoteDataSource {
  Future<void> postAbsensi(AbsensiRequestModel request);
}

@LazySingleton(as: IAbsensiRemoteDataSource)
class AbsensiRemoteDataSourceImpl implements IAbsensiRemoteDataSource {
  final Dio _dio;

  AbsensiRemoteDataSourceImpl(this._dio);

  @override
  Future<void> postAbsensi(AbsensiRequestModel request) async {
    try {
      // 1. Generate FormData (Otomatis handle tipe file dan struktur JSON di dalam form)
      final formData = await request.toFormData();

      // 2. Tentukan Endpoint (Check In vs Check Out)
      final endpoint = request.isCheckIn
          ? ApiEndpoints.pengawasCheckIn
          : ApiEndpoints.pengawasCheckOut;

      // 3. Tembak API (Dio otomatis set Content-Type ke multipart/form-data jika pakai FormData)
      final response = await _dio.post(endpoint, data: formData);

      // 4. Validasi Response standar Bapenda
      if (response.data['isSuccess'] == true) {
        return; // Berhasil, tidak perlu return data
      } else {
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message:
              response.data['message'] ?? 'Gagal memproses absensi pengawas',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Terjadi kesalahan koneksi saat absensi',
      );
    } catch (e) {
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }
}
