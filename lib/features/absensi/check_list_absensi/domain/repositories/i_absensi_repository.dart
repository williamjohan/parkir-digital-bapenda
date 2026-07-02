import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/absensi_entity.dart';

abstract class IAbsensiRepository {
  Future<Either<Failure, void>> postAbsensi(AbsensiEntity absensi);
}
