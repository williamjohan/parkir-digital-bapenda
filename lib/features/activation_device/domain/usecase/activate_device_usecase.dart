// domain/usecases/activate_device_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/device_repository.dart';

@lazySingleton
class ActivateDeviceUseCase {
  final DeviceRepository repository;

  ActivateDeviceUseCase(this.repository);

  Future<Either<Failure, bool>> execute({
    required String nop,
    required String deviceId,
  }) {
    return repository.activateDevice(nop: nop, deviceId: deviceId);
  }
}
