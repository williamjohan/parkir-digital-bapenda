import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/update_entity.dart';
import '../repositories/i_update_repository.dart';

@lazySingleton
class CheckUpdateUseCase {
  final IUpdateRepository _repository;

  CheckUpdateUseCase(this._repository);

  Future<Either<Failure, UpdateEntity?>> execute() async {
    return await _repository.checkUpdate();
  }
}
