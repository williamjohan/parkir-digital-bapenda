// data/repositories/device_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_remote_datasource.dart';

@LazySingleton(as: DeviceRepository)
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;

  DeviceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> activateDevice({
    required String nop,
    required String deviceId,
  }) async {
    try {
      final result = await remoteDataSource.activateDevice(
        nop: nop,
        deviceId: deviceId,
      );
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        final responseData = e.response?.data;

        String message = "Terjadi kesalahan";

        if (responseData != null && responseData is Map) {
          message = responseData['message'] ?? message;
        }

        return Left(ServerFailure(message));
      }

      // kalau dari throw Exception(message)
      if (e is Exception) {
        return Left(
          ServerFailure(e.toString().replaceFirst('Exception: ', '')),
        );
      }

      return Left(ServerFailure("Terjadi kesalahan tidak diketahui"));
    }
  }
}
