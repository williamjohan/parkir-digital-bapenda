import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/entities/riwayat_abensi_entity.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/repositories/i_riwayat_absensi_repositories.dart';
import '../../../../core/errors/failure.dart';

@lazySingleton
class RiwayatAbsensiUsecase {
  final IRiwayatAbsensiRepository _repository;

  RiwayatAbsensiUsecase(this._repository);

  Future<Either<Failure, List<RiwayatAbsensiEntity>>> getRiwayatAbsensiInfo({
    required DateTime tglAwal,
    required DateTime tglAkhir,
  }) async {
    return await _repository.getRiwayatAbsensiInfo(
      tglAwal: tglAwal,
      tglAkhir: tglAkhir,
    );
  }
}