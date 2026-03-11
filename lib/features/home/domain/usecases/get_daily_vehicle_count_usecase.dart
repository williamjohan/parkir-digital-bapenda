import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_home_repository.dart';

@lazySingleton
class GetDailyVehicleCountUseCase {
  final IHomeRepository repository;

  GetDailyVehicleCountUseCase(this.repository);

  Future<Either<Failure, Map<String, int>>> execute() {
    return repository.getDailyVehicleCount();
  }
}
