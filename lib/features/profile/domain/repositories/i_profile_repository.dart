// lib/features/profile/domain/repositories/i_profile_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/data/models/user_model.dart';

abstract class IProfileRepository {
  // Mengembalikan UserModel jika UI suatu saat butuh datanya langsung
  Future<Either<Failure, UserModel>> getProfile();
}
