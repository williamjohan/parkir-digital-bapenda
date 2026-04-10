// data/datasources/device_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class DeviceRemoteDataSource {
  Future<bool> activateDevice({required String nop, required String deviceId});
}

@LazySingleton(as: DeviceRemoteDataSource)
class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final Dio dio;

  DeviceRemoteDataSourceImpl(this.dio);

  @override
  Future<bool> activateDevice({
    required String nop,
    required String deviceId,
  }) async {
    final response = await dio.post(
      ApiEndpoints.activateDevice,
      data: {"nop": nop, "deviceId": deviceId},
    );

    final data = response.data;

    final isSuccess = data['isSuccess'] ?? false;
    final message = data['message'] ?? '';

    // ✅ SUCCESS NORMAL
    if (isSuccess == true) {
      return true;
    }

    // 🔥 ANGKAT JADI SUCCESS (CASE: SUDAH AKTIF)
    if (message.toLowerCase().contains("sudah aktif")) {
      return true;
    }

    // ❌ ERROR BENERAN
    throw Exception(message);
  }
}
