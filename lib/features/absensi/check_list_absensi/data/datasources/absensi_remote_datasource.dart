import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/data/models/alat_digital_model.dart';
import '../../../../../core/errors/exception.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/dio_error_handler.dart';
import '../../../../../core/services/image/i_image_service.dart';
import '../../../../../core/utils/app_logger.dart';
import '../models/absensi_model.dart';

abstract class IAbsensiRemoteDataSource {
  Future<void> postAbsensi(AbsensiRequestModel request);
  Future<List<AlatDigitalModel>> getAlatDigital();
}

@LazySingleton(as: IAbsensiRemoteDataSource)
class AbsensiRemoteDataSourceImpl implements IAbsensiRemoteDataSource {
  final Dio _dio;
  final IImageService _imageService;

  AbsensiRemoteDataSourceImpl(this._dio, this._imageService);

  @override
  Future<void> postAbsensi(AbsensiRequestModel request) async {
    String? compressedPath;

    try {
      final originalFile = File(request.fotoPath);

      if (await originalFile.exists()) {
        compressedPath = await _imageService.compressAndSaveImage(
          originalFile: originalFile,
          fileName:
              '${request.isCheckIn ? 'checkin' : 'checkout'}_${DateTime.now().millisecondsSinceEpoch}',
          maxTargetBytes: 350000,
          minResolution: 1024,
        );
      } else {
        AppLogger.warning(
          '>>> [ABSENSI] File foto tidak ditemukan di ${request.fotoPath}, lanjut tanpa kompresi (akan gagal di validasi toFormData).',
        );
      }

      // 1. Generate FormData — pakai foto hasil kompresi kalau berhasil,

      final formData = await request.toFormData(
        compressedFotoPath: compressedPath,
      );


      // 2. Tentukan Endpoint (Check In vs Check Out)
      final endpoint = request.isCheckIn
          ? ApiEndpoints.pengawasCheckIn
          : ApiEndpoints.pengawasCheckOut;

      // 3. Tembak API
      final response = await _dio.post(endpoint, data: formData);
      

      // 4. Validasi Response standar Bapenda
      if (response.data['isSuccess'] == true) {
        return;
      } else {
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message:
              response.data['message'] ?? 'Gagal memproses absensi pengawas',
        );
      }
    } on DioException catch (e) {
      // 🚀 FIX: sebelumnya ada logic error-handling terpisah di sini yang
      // fallback ke e.message (pesan teknis Dio, bahasa Inggris, tidak ramah
      // user). Sekarang konsisten dengan pengawasan_datasource.dart, dan
      // otomatis dapat pesan yang tepat untuk sendTimeout/receiveTimeout
      // (lihat dio_error_handler.dart).
      AppLogger.error('>>> [DIO ERROR] Absensi: ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Absensi', e, stackTrace);
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    } finally {
      // 5. Bersihkan file kompresi sementara di HP
      if (compressedPath != null) {
        _imageService.deleteImage(compressedPath).ignore();
      }
    }
  }

  @override
  Future<List<AlatDigitalModel>> getAlatDigital() async {
    try {
      final response = await _dio.get(ApiEndpoints.pengawasMasterAlatDigital);

      if (response.data['isSuccess'] == true) {
        final List<dynamic> rawList = response.data['data'] ?? [];
        return rawList
            .map(
              (json) => AlatDigitalModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message:
              response.data['message'] ?? 'Gagal mengambil data alat digital',
        );
      }
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR] AlatDigital: ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error AlatDigital', e, stackTrace);
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }
}
