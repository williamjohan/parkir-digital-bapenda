// lib/features/update/domain/usecases/check_update_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/update_entity.dart';
import '../repositories/i_update_repository.dart';

@injectable
class CheckUpdateUseCase {
  final IUpdateRepository repository;

  CheckUpdateUseCase(this.repository);

  Future<Either<Failure, UpdateEntity?>> execute() async {
    return await repository.checkUpdate();
  }
}
