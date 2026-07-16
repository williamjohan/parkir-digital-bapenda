import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/network/api_endpoints.dart';
import '../model/detail_realisasi_op_model.dart';

abstract class DetailRealisasiOpRemoteDataSource {
  Future<DetailRealisasiOpModel> getSummaryRealisasi({
    required String nop,
    required int tahun,
  });
}

@LazySingleton(as: DetailRealisasiOpRemoteDataSource)
class DetailRealisasiOpRemoteDataSourceImpl
    implements DetailRealisasiOpRemoteDataSource {
  final Dio _dio;

  DetailRealisasiOpRemoteDataSourceImpl(this._dio);

  @override
  Future<DetailRealisasiOpModel> getSummaryRealisasi({
    required String nop,
    required int tahun,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.summaryRealiasiOpDev,
        queryParameters: {'nop': nop, 'tahun': tahun.toString()},
      );

      final result = DetailRealisasiOpResponse.fromJson(response.data);

      if (result.isSuccess == true && result.data != null) {
        return result.data!;
      } else {
        throw Exception(result.message ?? 'Gagal mengambil data realisasi');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Terjadi kesalahan jaringan');
    }
  }
}
