import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../../core/errors/exception.dart';
import '../../../../../../core/utils/app_logger.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/dio_error_handler.dart';
import '../models/checkin_model.dart';
import '../models/checkout_model.dart';

abstract class AbsensiCheckInDatasource {
  Future<void> checkIn(CheckInModel model, File fotoCheckIn);
  Future<void> checkOut(CheckOutModel model, File fotoCheckOut);
}

@LazySingleton(as: AbsensiCheckInDatasource)
class AbsensiCheckInDatasourceImpl implements AbsensiCheckInDatasource {
  final Dio _dio;

  AbsensiCheckInDatasourceImpl(this._dio);

  @override
  Future<void> checkIn(CheckInModel model, File fotoCheckIn) async {
    try {
      AppLogger.info('Request Check In');

      final formData = FormData.fromMap({
        ..._modelToFormMap(model.toJson()),
        'FotoCheckIn': await MultipartFile.fromFile(
          fotoCheckIn.path,
          filename: fotoCheckIn.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.pengawasCheckIn,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final responseData = response.data;

      AppLogger.info('Response Check In: $responseData');

      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        AppLogger.info('Berhasil melakukan check in');
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
      AppLogger.error('Internal Error Check In', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses check in.',
      );
    }
  }

  @override
  Future<void> checkOut(CheckOutModel model, File fotoCheckOut) async {
    try {
      AppLogger.info('Request Check Out');

      final formData = FormData.fromMap({
        ..._modelToFormMap(model.toJson()),
        'FotoCheckOut': await MultipartFile.fromFile(
          fotoCheckOut.path,
          filename: fotoCheckOut.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.pengawasCheckOut,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final responseData = response.data;

      AppLogger.info('Response Check Out: $responseData');

      if (responseData['isSuccess'] == true &&
          responseData['statusCode'] == 200) {
        AppLogger.info('Berhasil melakukan check out');
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
      AppLogger.error('Internal Error Check Out', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memproses check out.',
      );
    }
  }

  /// Ubah hasil `model.toJson()` jadi Map yang siap dilempar ke
  /// `FormData.fromMap`. Field biasa (angka/string) lolos apa adanya.
  /// Field `DetailAlatList` (array of object) di-flatten pakai notasi
  /// bracket `DetailAlatList[0].id`, `DetailAlatList[1].id`, dst — ini
  /// konvensi umum buat binding array-of-object di multipart form (ASP.NET
  /// Core style), sesuai bentuk input di Swagger yang kamu kirim.
  ///
  /// KALAU ternyata backend maunya format lain (misal satu field JSON
  /// string), tinggal ganti isi method ini, contoh:
  /// ```dart
  /// map['DetailAlatList'] = jsonEncode(json['DetailAlatList']);
  /// ```
  Map<String, dynamic> _modelToFormMap(Map<String, dynamic> json) {
    final map = <String, dynamic>{};

    json.forEach((key, value) {
      if (key == 'DetailAlatList' && value is List) {
        for (var i = 0; i < value.length; i++) {
          final item = value[i] as Map<String, dynamic>;
          item.forEach((itemKey, itemValue) {
            map['DetailAlatList[$i].$itemKey'] = itemValue.toString();
          });
        }
      } else {
        map[key] = value.toString();
      }
    });

    return map;
  }
}