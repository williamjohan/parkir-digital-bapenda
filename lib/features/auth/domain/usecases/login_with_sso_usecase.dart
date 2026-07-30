import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_auth_repository.dart';

@lazySingleton
class LoginWithSsoUseCase {
  final IAuthRepository repository;

  LoginWithSsoUseCase(this.repository);

  Future<Either<Failure, void>> call(String sessionId) {
    return repository.loginWithKantorkuSession(sessionId);
  }
}
