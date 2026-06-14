import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_qris_repository.dart';

@lazySingleton
class GetLocalQrisUseCase {
  final IQrisRepository _repository;

  GetLocalQrisUseCase(this._repository);

  Future<Either<Failure, Map<String, String>>> execute() {
    return _repository.getLocalQrisPaths();
  }
}
