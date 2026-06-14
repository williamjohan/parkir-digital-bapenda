import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../models/qris_rompi_model.dart';

abstract class IQrisRemoteDataSource {
  Future<List<QrisRompiModel>> getQrisRompi();
}

@LazySingleton(as: IQrisRemoteDataSource)
class QrisRemoteDataSourceImpl implements IQrisRemoteDataSource {
  final Dio _dio;

  QrisRemoteDataSourceImpl(this._dio);

  @override
  Future<List<QrisRompiModel>> getQrisRompi() async {
    try {
      // 🚀 Sesuai konfirmasi: Menggunakan murni GET
      final response = await _dio.get('/api/mobile/parking/get-qris-rompi');

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        final List<dynamic> dataList = response.data['data'] ?? [];
        return dataList.map((json) => QrisRompiModel.fromJson(json)).toList();
      } else {
        // 🚀 Menggunakan format ServerException Anda
        throw ServerException(
          statusCode: response.statusCode ?? 500,
          message: response.data['message'] ?? 'Gagal mengambil data QRIS',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Terjadi kesalahan jaringan',
      );
    }
  }
}
