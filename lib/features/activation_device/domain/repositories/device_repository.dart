// domain/repositories/device_repository.dart

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

abstract class DeviceRepository {
  Future<Either<Failure, bool>> activateDevice({
    required String nop,
    required String deviceId,
  });
}
