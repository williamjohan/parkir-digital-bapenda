import 'package:dartz/dartz.dart';
import 'package:parkir_digital_bapenda/features/home/domain/entities/dashboard_summary_jukir_entity.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/errors/failure.dart';
import '../entities/dashboard_summary_non_jukir_entity.dart';
import '../entities/dashboard_summary_pengawas.entity.dart';

abstract class IHomeRepository {
  Future<Either<Failure, DashboardSummaryJukirEntity>>
  getDashboardSummaryJukir({required String nop});

  Future<Either<Failure, DashboardSummaryNonJukirEntity>>
  getDashboardSummaryNonJukir();

  Future<Either<Failure, DashboardSummaryNonJukirEntity>>
  getDashboardSummaryNonJukirRange({String? tglAwal, String? tglAkhir});

  Future<Either<Failure, DashboardSummaryPengawasEntity>>
  getDashboardSummaryPengawas({
    required String nomorObjek,
    required int shift,
    required String jenis,
  });

  Future<Either<Failure, bool>> getOpLastUpdate();

  String? getNomorObjekPengawasan();
  ShiftPengawasan? getShiftObjekPengawasan();
  JenisPengawasan? getJenisObjekPengawasan();
}
