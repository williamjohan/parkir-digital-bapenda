import 'package:dio/dio.dart';
import '../models/absensi_model.dart';
import 'absensi_dummy_datasource.dart';

class AbsensiRemoteDataSource implements IAbsensiDataSource {
  final Dio dio;

  AbsensiRemoteDataSource({required this.dio});

  @override
  Future<AbsensiModel> getAbsensiHariIni() async {
    final response = await dio.get('/api/v1/absensi/hari-ini');
    return AbsensiModel.fromJson(response.data['data']);
  }

  @override
  Future<AbsensiModel> submitAbsenMasuk(AbsensiModel data) async {
    final response = await dio.post(
      '/api/v1/absensi/masuk',
      data: data.toJson(),
    );
    return AbsensiModel.fromJson(response.data['data']);
  }

  @override
  Future<AbsensiModel> submitAbsenPulang(AbsensiModel data) async {
    final response = await dio.post(
      '/api/v1/absensi/pulang',
      data: data.toJson(),
    );
    return AbsensiModel.fromJson(response.data['data']);
  }
}
