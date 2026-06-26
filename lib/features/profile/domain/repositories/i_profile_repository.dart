import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/data/models/user_model.dart';

abstract class IProfileRepository {
  Future<Either<Failure, UserModel>> getProfile();
}
