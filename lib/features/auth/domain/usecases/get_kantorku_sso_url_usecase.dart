import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_auth_repository.dart';

@lazySingleton
class GetKantorkuSsoUrlUseCase {
  final IAuthRepository repository;

  GetKantorkuSsoUrlUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.getKantorkuSsoUrl();
  }
}
