import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/qris_entity.dart';
import '../repositories/i_qris_repository.dart';

@lazySingleton
class QrisUsecase {
  final IQrisRepository _repository;

  QrisUsecase(this._repository);

  Future<Either<Failure, Map<String, QrisLocalEntity>>> getLocalQris() {
    return _repository.getLocalQrisMetaDatas();
  }

  Future<Either<Failure, Unit>> syncQris() {
    return _repository.syncQrisToLocal();
  }
}
