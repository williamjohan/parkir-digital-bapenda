import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class IHomeRepository {
  /// Mengambil total kendaraan (Motor & Mobil) hari ini
  Future<Either<Failure, Map<String, int>>> getDailyVehicleCount();
}
