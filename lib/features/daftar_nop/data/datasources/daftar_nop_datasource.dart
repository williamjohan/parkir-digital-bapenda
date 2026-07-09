import '../models/daftar_nop_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class DaftarNopDatasource {
  Future<List<DaftarNopModel>> getDaftarNop();
}

@LazySingleton(as: DaftarNopDatasource)
class DaftarNopDatasourceImpl implements DaftarNopDatasource {
  final Dio dio;

  DaftarNopDatasourceImpl(this.dio);

  @override
  Future<List<DaftarNopModel>> getDaftarNop() async {
    final response = await dio.get(ApiEndpoints.listNopDev);

    final List data = response.data['data'];

    return data.map((e) => DaftarNopModel.fromJson(e)).toList();
  }
}
