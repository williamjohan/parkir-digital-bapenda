import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../../core/errors/exception.dart';
import '../../../../../../core/utils/app_logger.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/dio_error_handler.dart';
import '../../../../core/services/image/i_image_service.dart';
import '../../domain/entities/request_laporan_pengawasan_entity/request_laporan_pengawasan_entity.dart';
import '../models/laporan_pengawasan/laporan_pengawasan_model.dart';

abstract class PengawasanDatasource {
  Future<List<LaporanPengawasanModel>> getLaporanPengawasan();

  Future<void> addPengawasan(RequestLaporanPengawasanEntity request);
}

@LazySingleton(as: PengawasanDatasource)
class PengawasanDatasourceImpl implements PengawasanDatasource {
  final IImageService _imageService;
  final Dio _dio;

  DioMediaType _getMediaType(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return DioMediaType('image', 'png');
      case 'webp':
        return DioMediaType('image', 'webp');
      case 'heic':
      case 'heif':
        return DioMediaType('image', 'heic');
      case 'jpg':
      case 'jpeg':
      default:
        return DioMediaType('image', 'jpeg');
    }
  }

  PengawasanDatasourceImpl(this._dio, this._imageService);

  @override
  Future<List<LaporanPengawasanModel>> getLaporanPengawasan() async {
    try {
      AppLogger.info('Request Get Laporan Pengawasan');

      final response = await _dio.get(ApiEndpoints.pengawasLaporanList);

      AppLogger.info(
        'Response Get Laporan Pengawasan: ${response.data['data']?.length} laporan',
      );

      if (response.statusCode != 200) {
        throw ServerException(
          statusCode: response.statusCode ?? 500,
          message: response.data?['message'] ?? 'Gagal mengambil data laporan.',
        );
      }

      final List<dynamic> data = response.data['data'];

      return data
          .map(
            (e) => LaporanPengawasanModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR] ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Get Laporan Pengawasan', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal.',
      );
    }
  }

  @override
  Future<void> addPengawasan(RequestLaporanPengawasanEntity request) async {
    String? compressedPath;

    try {
      AppLogger.info('Request Add Pengawasan');

      MultipartFile? buktiFotoMultipart;

      // 1. Cek apakah ada foto yang dilampirkan
      if (request.buktiFoto != null && request.buktiFoto!.path.isNotEmpty) {
        final originalFile = File(request.buktiFoto!.path);

        if (await originalFile.exists()) {
          // Kompresi Gambar
          compressedPath = await _imageService.compressAndSaveImage(
            originalFile: originalFile,
            fileName: 'pengawasan_${DateTime.now().millisecondsSinceEpoch}',
            maxTargetBytes: 350000,
            minResolution: 1024,
          );

          // Jika kompresi berhasil pakai file kompresi, jika gagal otomatis fallback ke file asli HP
          final finalFile = File(compressedPath ?? originalFile.path);
          final bytes = await finalFile.readAsBytes();

          // 🚀 2. DYNAMIC MEDIA TYPE: Berjalan otomatis untuk JPG, JPEG, PNG, WEBP!
          buktiFotoMultipart = MultipartFile.fromBytes(
            bytes,
            filename: finalFile.path.split('/').last,
            contentType: _getMediaType(
              finalFile.path,
            ), // <-- Otomatis menyesuaikan!
          );
        }
      }

      // 3. Build Payload
      final mapData = <String, dynamic>{
        'JenisPel': request.jenisPel,
        'KetPel': request.ketPel,
      };

      if (buktiFotoMultipart != null) {
        mapData['BuktiFoto'] = buktiFotoMultipart;
      } else {
        mapData['BuktiFoto'] = ''; // Sesuai trial Swagger jika foto kosong
      }

      final formData = FormData.fromMap(mapData);

      final response = await _dio.post(
        ApiEndpoints.addPengawasanPelaporanDev,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      AppLogger.info('Response Add Pengawasan: ${response.data}');

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
    } finally {
      // 4. Bersihkan file kompresi sementara di HP pengawas
      if (compressedPath != null) {
        _imageService.deleteImage(compressedPath).ignore();
      }
    }
  }
}
