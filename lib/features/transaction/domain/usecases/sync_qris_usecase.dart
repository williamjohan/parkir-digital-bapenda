import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_qris_repository.dart';

@lazySingleton
class SyncQrisUseCase {
  final IQrisRepository _repository;

  SyncQrisUseCase(this._repository);

  Future<Either<Failure, Unit>> execute() {
    return _repository.syncQrisToLocal();
  }
}
