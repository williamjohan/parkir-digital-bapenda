import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/entities/riwayat_abensi_entity.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/repositories/i_riwayat_absensi_repositories.dart';
import 'package:parkir_digital_bapenda/features/jadwal/data/model/riwayat_absensi_model.dart'; // 👈 tambahin ini
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/riwayat_absensi_datasource.dart';

@LazySingleton(as: IRiwayatAbsensiRepository)
class RiwayatAbsensiRepositoryImpl implements IRiwayatAbsensiRepository {
  final IRiwayatAbsensiDataSource _remoteDataSource;

  RiwayatAbsensiRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<RiwayatAbsensiEntity>>> getRiwayatAbsensiInfo({
    required DateTime tglAwal,
    required DateTime tglAkhir,
  }) async {
    try {
      final listModel = await _remoteDataSource.getRiwayatAbsensiInfo(
        tglAwal: tglAwal,
        tglAkhir: tglAkhir,
      );
      return Right(listModel.toEntityList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure("Gagal memuat data jadwal."));
    }
  }
}
