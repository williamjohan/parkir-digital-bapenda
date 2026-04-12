import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../data/datasource/status_device_remote_datasource.dart';

@lazySingleton
class CheckStatusDeviceUseCase {
  final StatusDeviceRemoteDataSource remoteDataSource;

  CheckStatusDeviceUseCase(this.remoteDataSource);

  Future<Either<Failure, bool>> execute(String deviceId) async {
    return await remoteDataSource.checkStatusDevice(deviceId);
  }
}