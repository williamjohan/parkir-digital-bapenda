// lib/features/auth/domain/usecases/check_device_uuid_usecase.dart

import 'package:injectable/injectable.dart';
import '../repositories/i_auth_repository.dart';

@lazySingleton
class CheckDeviceUuidUseCase {
  final IAuthRepository _repository;

  CheckDeviceUuidUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.checkDeviceUuid();
  }
}
