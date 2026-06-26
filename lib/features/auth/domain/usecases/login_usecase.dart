import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_auth_repository.dart';

@lazySingleton
class LoginUseCase {
  final IAuthRepository _repository;

  LoginUseCase(this._repository);

  /// Fungsi [call] memungkinkan class ini dipanggil seperti function biasa:
  /// final result = await loginUseCase('willi', '123456');
  Future<Either<Failure, Unit>> call(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return const Left(
        AuthFailure('Username dan password tidak boleh kosong.'),
      );
    }

    return await _repository.login(username, password);
  }
}
