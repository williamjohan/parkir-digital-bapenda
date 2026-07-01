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
        'JenisPel': model.jenisPel,
        'KetPel': model.ketPel,
        'BuktiFoto': await MultipartFile.fromFile(
          buktiFoto.path,
          filename: buktiFoto.path.split('/').last,
          contentType: DioMediaType('image', 'png'),
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.addPengawasanPelaporanDev,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      AppLogger.info('Response Add Pengawasan: ${response.data}');

      // Jika HTTP berhasil (200/201/204), anggap sukses
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return;
      }

      throw ServerException(
        statusCode: response.statusCode ?? 500,
        message: response.data?['message'] ?? 'Gagal mengirim laporan.',
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
