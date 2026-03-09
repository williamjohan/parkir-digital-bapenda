// lib/features/auth/domain/usecases/check_auth_status_usecase.dart

import 'package:injectable/injectable.dart';
import '../repositories/i_auth_repository.dart';

@lazySingleton
class CheckAuthStatusUseCase {
  final IAuthRepository _repository;

  CheckAuthStatusUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.checkAuthStatus();
  }
}
