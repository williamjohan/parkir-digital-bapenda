import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../repositories/i_profile_repository.dart';

@lazySingleton
class ProfileUseCase {
  final IProfileRepository _repository;

  ProfileUseCase(this._repository);

  Future<Either<Failure, UserEntity>> getProfileInfo({
    bool forceRefresh = false,
  }) {
    return _repository.getProfileInfo(forceRefresh: forceRefresh);
  }

  Future<Either<Failure, String>> getProfilePicturePath({
    bool forceRefresh = false,
  }) {
    return _repository.getProfilePicturePath(forceRefresh: forceRefresh);
  }
}
