import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_auth_repository.dart';

@lazySingleton
class LoginUseCase {
  final IAuthRepository _repository;

  LoginUseCase(this._repository);

  // 1. Login Reguler
  Future<Either<Failure, Unit>> loginReguler(
    String username,
    String password,
  ) async {
    if (username.isEmpty || password.isEmpty) {
      return const Left(
        AuthFailure('Username dan password tidak boleh kosong.'),
      );
    }
    return await _repository.login(username, password);
  }

  // 2. Login SSO
  Future<Either<Failure, Unit>> loginWithSso(String sessionId) async {
    return await _repository.loginWithKantorkuSession(sessionId);
  }

  // 3. Get SSO URL
  Future<Either<Failure, String>> getKantorkuSsoUrl() async {
    return await _repository.getKantorkuSsoUrl();
  }

  // 4. Stream SSO
  Stream<String> get ssoTokenStream => _repository.ssoTokenStream;

  // 5. Save Credentials (Remember Me)
  Future<void> saveCredentials(String username, String password) async {
    await _repository.saveCredentials(username, password);
  }
}
