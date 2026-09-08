import 'package:injectable/injectable.dart';
import '../repositories/i_auth_repository.dart';

@lazySingleton
class GetSsoTokenStreamUseCase {
  final IAuthRepository repository;

  GetSsoTokenStreamUseCase(this.repository);

  Stream<String> call() {
    return repository.ssoTokenStream;
  }
}
