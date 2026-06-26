import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/data/models/user_model.dart';
import '../repositories/i_profile_repository.dart';

@lazySingleton
class GetProfileUseCase {
  final IProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Either<Failure, UserModel>> call() async {
    return await _repository.getProfile();
  }
}
