// data/repositories/device_repository_impl.dart

import 'package:dartz/dartz.dart';
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
      return Left(ServerFailure(e.toString()));
    }
  }
}
