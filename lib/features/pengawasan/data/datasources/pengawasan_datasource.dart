import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../../core/errors/exception.dart';
import '../../../../../../core/utils/app_logger.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/dio_error_handler.dart';
import '../models/add_pengawasan_model.dart';

abstract class PengawasanDatasource {
  Future<void> addPengawasan(AddPengawasanModel model, File buktiFoto);
}

@LazySingleton(as: PengawasanDatasource)
class PengawasanDatasourceImpl implements PengawasanDatasource {
  final Dio _dio;

  PengawasanDatasourceImpl(this._dio);

  @override
  Future<void> addPengawasan(AddPengawasanModel model, File buktiFoto) async {
    try {
      AppLogger.info('Request Add Pengawasan');

      final formData = FormData.fromMap({
        ...model.toJson(),
        'BuktiFoto': await MultipartFile.fromFile(
          buktiFoto.path,
          filename: buktiFoto.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.addPengawasanPelaporanDev,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final responseData = response.data;

      AppLogger.info('Response Add Pengawasan: $responseData');

      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        AppLogger.info('Berhasil menambahkan laporan pengawasan');
        return;
      }

      throw ServerException(
        statusCode: responseData['statusCode'] ?? 500,
        message: responseData['message'] ?? 'Terjadi kesalahan.',
      );
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR] ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Add Pengawasan', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses laporan.',
      );
    }
  }
}
