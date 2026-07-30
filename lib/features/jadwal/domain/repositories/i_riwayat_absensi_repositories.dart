import 'package:dartz/dartz.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/entities/riwayat_abensi_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class IRiwayatAbsensiRepository {
  Future<Either<Failure, List<RiwayatAbsensiEntity>>> getRiwayatAbsensiInfo({
    required DateTime tglAwal,
    required DateTime tglAkhir,
  });
}