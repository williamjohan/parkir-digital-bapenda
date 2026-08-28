import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_auth_repository.dart';

@lazySingleton
class AuthUseCase {
  final IAuthRepository _repository;

  AuthUseCase(this._repository);

  // 1. Cek Status Otentikasi (Token valid/tidak)
  Future<bool> checkAuthStatus() async {
    return await _repository.checkAuthStatus();
  }

  // 2. Logout dari aplikasi
  Future<Either<Failure, Unit>> logout() async {
    return await _repository.logout();
  }

  // 3. Validasi Device UUID (Single Device Login)
  Future<bool> checkDeviceUuid() async {
    return await _repository.checkDeviceUuid();
  }
}
