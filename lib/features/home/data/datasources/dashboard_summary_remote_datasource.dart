import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:parkir_digital_bapenda/core/network/api_endpoints.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/counter/counter_data_model.dart';
import '../models/dashboard_summary_jukir/dashboard_summary_jukir_model.dart';
import '../models/dashboard_summary_non_jukir/dashboard_summary_non_jukir_model.dart';
import '../models/dashboard_summary_pengawas/dashboard_summary_pengawas_model.dart';
import '../models/dashboard_summary_pengawas/rekap_wilayah_model.dart';
import '../models/op_last_update/op_last_update_model.dart';

abstract class ISummaryRemoteDataSource {
  Future<DashboardSummaryJukirModel> getDashboardSummaryJukir({
    required String nop,
  });
  Future<DashboardSummaryNonJukirModel> getDashboardSummaryNonJukir();
  Future<DashboardSummaryNonJukirModel> getDashboardSummaryNonJukirRange({
    String? tglAwal,
    String? tglAkhir,
  });
  Future<DashboardSummaryPengawasModel> getDashboardSummaryPengawas({
    required String nomorObjek,
    required int shift,
    required int jenis,
  });

  Future<OpLastUpdateModel> getOpLastUpdate();
  Future<RekapWilayahResponseModel> getRekapWilayah();
  Future<CounterDataModel> getCounterData();
  Future<void> insertCounterData({
    required int jumlahMotor,
    required int jumlahMobil,
  });
}

@LazySingleton(as: ISummaryRemoteDataSource)
class SummaryRemoteDataSourceImpl implements ISummaryRemoteDataSource {
  final Dio _dio;

  SummaryRemoteDataSourceImpl(this._dio);

  @override
  Future<DashboardSummaryJukirModel> getDashboardSummaryJukir({
    required String nop,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.dashboardSummaryDev,
        queryParameters: {'nop': nop},
      );

      if (response.data['isSuccess'] == true) {
        return DashboardSummaryJukirModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message:
              response.data['message'] ?? 'Gagal mengambil summary dashboard',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Terjadi kesalahan koneksi saat memuat dashboard',
      );
    } catch (e) {
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }

  @override
  Future<DashboardSummaryNonJukirModel> getDashboardSummaryNonJukir() async {
    try {
      final response = await _dio.get(ApiEndpoints.dashboardSummaryNonJukirDev);

      if (response.data['isSuccess'] == true) {
        return DashboardSummaryNonJukirModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message:
              response.data['message'] ?? 'Gagal mengambil summary dashboard',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Terjadi kesalahan koneksi saat memuat dashboard',
      );
    } catch (e) {
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }

  @override
  Future<DashboardSummaryNonJukirModel> getDashboardSummaryNonJukirRange({
    String? tglAwal,
    String? tglAkhir,
  }) async {
    try {
      final now = DateTime.now();

      String formatDate(String? date) {
        if (date == null || date.trim().isEmpty) {
          return DateFormat('yyyy-MM-dd').format(now);
        }

        try {
          return DateFormat('yyyy-MM-dd').format(DateTime.parse(date.trim()));
        } catch (_) {
          return date.trim();
        }
      }

      final response = await _dio.get(
        ApiEndpoints.summaryRangeDev,
        queryParameters: {
          'tglAwal': formatDate(tglAwal),
          'tglAkhir': formatDate(tglAkhir),
        },
      );

      if (response.data['isSuccess'] == true) {
        return DashboardSummaryNonJukirModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          statusCode: response.data['statusCode'] ?? response.statusCode ?? 500,
          message:
              response.data['message'] ?? 'Gagal mengambil summary dashboard',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Terjadi kesalahan koneksi saat memuat dashboard',
      );
    } catch (e) {
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }

  @override
  Future<DashboardSummaryPengawasModel> getDashboardSummaryPengawas({
    required String nomorObjek,
    required int shift,
    required int jenis,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.pengawasDashboardRosterSummaryDev,
        queryParameters: {
          'nomorObjek': nomorObjek,
          'shift': shift,
          'jenis': jenis,
        },
      ); // Sesuaikan endpoint

      final result = DashboardSummaryPengawasModel.fromJson(response.data);

      if (result.isSuccess == true) {
        return result;
      } else {
        throw ServerException(
          statusCode: result.statusCode != 0 ? result.statusCode : 500,
          message: result.message.isNotEmpty
              ? result.message
              : 'Gagal mengambil summary dashboard pengawas',
        );
      }
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR] ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Get Dashboard Pengawas', e, stackTrace);

      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal.',
      );
    }
  }

  @override
  Future<OpLastUpdateModel> getOpLastUpdate() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.opLastUpdate,
      ); // Sesuaikan endpoint

      final result = OpLastUpdateModel.fromJson(response.data);

      if (result.isSuccess == true) {
        return result;
      } else {
        throw ServerException(
          statusCode: result.statusCode != 0 ? result.statusCode : 500,
          message: result.message.isNotEmpty
              ? result.message
              : 'Gagal mengambil tanggal perubahan data objek pajak',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        statusCode: e.response?.statusCode ?? 500,
        message:
            e.message ??
            'Terjadi kesalahan koneksi saat memuat data objek pajak',
      );
    } catch (e) {
      throw ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal: ${e.toString()}',
      );
    }
  }

  @override
  Future<RekapWilayahResponseModel> getRekapWilayah() async {
    try {
      final response = await _dio.get(ApiEndpoints.homeScreenPengawas);

      final result = RekapWilayahResponseModel.fromJson(response.data);

      if (result.isSuccess == true) {
        return result;
      } else {
        throw ServerException(
          statusCode: (result.statusCode != null && result.statusCode != 0)
              ? result.statusCode!
              : 500,
          message: result.message?.isNotEmpty == true
              ? result.message!
              : 'Gagal mengambil data rekap Objek Pengawasan wilayah',
        );
      }
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR] getRekapWilayah: ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Get Rekap Wilayah', e, stackTrace);
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memuat rekap wilayah.',
      );
    }
  }

 @override
  Future<CounterDataModel> getCounterData() async {
    try {
      final response = await _dio.get(ApiEndpoints.getDataCounter);

      final result = CounterDataResponseModel.fromJson(response.data);

      if (result.isSuccess == true && result.data != null) {
        return result.data!;
      } else {
        throw ServerException(
          statusCode: (result.statusCode != null && result.statusCode != 0)
              ? result.statusCode!
              : 500,
          message: result.message?.isNotEmpty == true
              ? result.message!
              : 'Gagal mengambil data counter kendaraan',
        );
      }
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR] getCounterData: ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Get Counter Data', e, stackTrace);
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat memuat data counter.',
      );
    }
  }

  @override
  Future<void> insertCounterData({
    required int jumlahMotor,
    required int jumlahMobil,
  }) async {
    try {
      final payload = {
        "jumlahMotor": jumlahMotor,
        "jumlahMobil": jumlahMobil,
      };

      final response = await _dio.post(
        ApiEndpoints.insertDataCounter,
        data: payload,
      );

      final result = InsertCounterResponseModel.fromJson(response.data);

      if (result.isSuccess == true) {
        return; // Berhasil, keluar dari fungsi tanpa error
      } else {
        throw ServerException(
          statusCode: (result.statusCode != null && result.statusCode != 0)
              ? result.statusCode!
              : 500,
          message: result.message?.isNotEmpty == true
              ? result.message!
              : 'Gagal mengirim data pencatatan kendaraan',
        );
      }
    } on DioException catch (e) {
      AppLogger.error('>>> [DIO ERROR] insertCounterData: ${e.response?.data}');
      throw DioErrorHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.error('Internal Error Insert Counter Data', e, stackTrace);
      throw const ServerException(
        statusCode: 500,
        message: 'Terjadi kesalahan internal saat mencatat kendaraan.',
      );
    }
  }
}
