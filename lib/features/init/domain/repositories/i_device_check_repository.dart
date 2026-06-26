import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class IDeviceCheckRepository {
  /// Mengecek apakah perangkat memiliki layanan Google Play Services yang aktif.
  /// Mengembalikan [bool] true jika tersedia, false jika tidak.
  Future<Either<Failure, bool>> checkPlayServicesAvailability();

  /// (Opsional tapi direkomendasikan) Mengecek apakah storage cukup untuk download ML Model
  Future<Either<Failure, bool>> checkStorageSufficient();
}
