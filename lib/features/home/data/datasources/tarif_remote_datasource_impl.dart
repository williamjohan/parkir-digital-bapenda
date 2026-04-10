import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/tarif_model.dart';
import 'i_tarif_remote_datasource.dart';

@LazySingleton(as: ITarifRemoteDataSource)
class TarifRemoteDataSourceImpl implements ITarifRemoteDataSource {
  final Dio _dio;

  TarifRemoteDataSourceImpl(this._dio);

  @override
  Future<List<TarifModel>> getTarif() async {
    try {
      final response = await _dio.get(ApiEndpoints.tarif);

      if (response.data['isSuccess'] == true) {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((json) => TarifModel.fromJson(json)).toList();
      } else {
        // Melempar ServerException lengkap dengan statusCode dari body API
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message: response.data['message'] ?? 'Gagal mengambil data tarif',
        );
      }
    } on DioException catch (e) {
      // Menangkap error dari Dio (Timeout, 404, 500)
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Terjadi kesalahan koneksi',
      );
    } catch (e) {
      // Fallback untuk error parsing JSON atau lainnya
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }
}
