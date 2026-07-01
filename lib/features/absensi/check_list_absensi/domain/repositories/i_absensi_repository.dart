import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/absensi_entity.dart';

abstract class IAbsensiRepository {
  Future<Either<Failure, AbsensiEntity>> getAbsensiHariIni();
  Future<Either<Failure, AbsensiEntity>> submitAbsensi(AbsensiEntity data);
}
