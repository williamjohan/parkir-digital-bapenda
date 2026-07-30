import 'package:dartz/dartz.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/domain/entities/alat_digital_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/absensi_entity.dart';

abstract class IAbsensiRepository {
  Future<Either<Failure, void>> postAbsensi(AbsensiEntity absensi);
   Future<Either<Failure, List<AlatDigitalEntity>>> getAlatDigital();
}
