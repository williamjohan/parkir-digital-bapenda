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
    final jsonUrl = dotenv.env['UPDATE_JSON_URL'] ?? '';

    final response = await _dio.get(
      jsonUrl,
      options: Options(
        headers: {
          "Cache-Control": "no-cache",
          "Pragma": "no-cache",
          "Expires": "0",
        },
      ),
    );

    // 🚀 TAMBAHAN: Cek jika response kosong
    if (response.data == null || response.data.toString().isEmpty) {
      throw Exception("Server mengembalikan data kosong.");
    }

    if (response.data is String) {
      final String cleanJson = (response.data as String).replaceAll(
        RegExp(r'[\r\n\t]+'),
        '',
      );
      return jsonDecode(cleanJson);
    }

    // Pastikan data adalah Map sebelum dikembalikan
    if (response.data is Map<String, dynamic>) {
      return response.data;
    }

    throw Exception("Format data tidak dikenal.");
  }
}
