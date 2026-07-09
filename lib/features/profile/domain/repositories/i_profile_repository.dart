import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class IProfileRepository {
  Future<Either<Failure, UserEntity>> getProfileInfo({
    bool forceRefresh = false,
  });

  Future<Either<Failure, String>> getProfilePicturePath({
    bool forceRefresh = false,
  });
}
