import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

abstract class IUpdateRemoteDataSource {
  Future<Map<String, dynamic>> fetchUpdateJson();
}

@LazySingleton(as: IUpdateRemoteDataSource)
class UpdateRemoteDataSourceImpl implements IUpdateRemoteDataSource {
  final Dio _dio;

  UpdateRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> fetchUpdateJson() async {
    final jsonUrl = dotenv.env['UPDATE_JSON_TESTING_URL'] ?? '';
    final response = await _dio.get(jsonUrl);

    if (response.data is String) {
      return jsonDecode(response.data);
    }
    return response.data;
  }
}
