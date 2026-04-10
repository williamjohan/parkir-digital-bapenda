import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_home_repository.dart';

@lazySingleton
class SyncTarifUseCase {
  final IHomeRepository repository;

  SyncTarifUseCase(this.repository);

  Future<Either<Failure, void>> execute() {
    return repository.syncTarif();
  }
}
