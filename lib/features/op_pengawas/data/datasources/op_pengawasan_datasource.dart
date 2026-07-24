import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/op_pengawasan_model.dart';

abstract class OpPengawasanDatasource {
  Future<List<OpPengawasanModel>> getOpPengawasan();
}

@LazySingleton(as: OpPengawasanDatasource)
class OpPengawasanDatasourceImpl implements OpPengawasanDatasource {
  final Dio _dio;

  OpPengawasanDatasourceImpl(this._dio);

  @override
  Future<List<OpPengawasanModel>> getOpPengawasan() async {
    try {
      AppLogger.info('Request Get OP Pengawasan');

      final response = await _dio.get(ApiEndpoints.opPengawasList);

      AppLogger.info(
        'Response Get OP Pengawasan : ${response.data['data']?.length} data',
      );

      if (response.statusCode != 200) {
        throw ServerException(
          statusCode: response.statusCode ?? 500,
          message:
              response.data?['message'] ??
              'Gagal mengambil data OP Pengawasan.',
        );
      }

      final List<dynamic> data = response.data['data'];

      return data
          .map((e) => OpPengawasanModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR] ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Get OP Pengawasan', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal.',
      );
    }
  }
}
