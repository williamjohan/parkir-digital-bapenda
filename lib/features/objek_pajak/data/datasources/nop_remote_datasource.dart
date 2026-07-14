import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/objek_pajak/data/models/nop/nop_model.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class INopRemoteDataSource {
  Future<NopModel> getNopList();
}

@LazySingleton(as: INopRemoteDataSource)
class NopRemoteDataSourceImpl implements INopRemoteDataSource {
  final Dio _dio;

  NopRemoteDataSourceImpl(this._dio);

  @override
  Future<NopModel> getNopList() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.listNopDev,
      ); // Sesuaikan endpoint

      final result = NopModel.fromJson(response.data);

      if (result.isSuccess == true) {
        return result;
      } else {
        throw ServerException(
          statusCode: result.statusCode != 0 ? result.statusCode : 500,
          message: result.message.isNotEmpty
              ? result.message
              : 'Gagal mengambil data objek pajak',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message:
            e.message ?? 'Terjadi kesalahan koneksi saat memuat objek pajak',
      );
    } catch (e) {
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }
}
