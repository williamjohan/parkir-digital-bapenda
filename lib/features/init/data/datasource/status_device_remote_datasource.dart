import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class StatusDeviceRemoteDataSource {
  Future<Either<Failure, bool>> checkStatusDevice(String deviceId);
}

@LazySingleton(as: StatusDeviceRemoteDataSource)
class DeviceRemoteDataSourceImpl implements StatusDeviceRemoteDataSource {
  final Dio dio;

  DeviceRemoteDataSourceImpl(this.dio);

  @override
  Future<Either<Failure, bool>> checkStatusDevice(String deviceId) async {
    try {
      final response = await dio.post(
        ApiEndpoints.checkStatusDevice,
        data: {
          "deviceId": deviceId,
        },
      );

      final data = response.data;

      return Right(data['data'] as bool);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}