import '../../domain/entities/dashboard_summary_non_jukir_entity.dart';
import '../models/dashboard_summary_non_jukir/dashboard_summary_non_jukir_model.dart';
import '../models/sof/sof_parkir_result_model.dart';

extension DashboardSummaryNonJukirMapper on DashboardSummaryNonJukirModel {
  DashboardSummaryNonJukirEntity toEntity() {
    return DashboardSummaryNonJukirEntity(
      totalOp: totalOp,
      totalOpDigital: totalOpDigital,
      totalOpNonDigital: totalOpNonDigital,
      jumlahMotorHariIni: jumlahMotorHariIni,
      jumlahMobilHariIni: jumlahMobilHariIni,
      totalNominalHariIni: totalNominalHariIni,
      totalNominalBersihUntukWajibPajak: totalNominalBersihUntukWajibPajak,
      totalNominalBersihUntukBapenda: totalNominalBersihUntukBapenda,
      sofParkirResults: sofParkirResults.map((e) => e.toEntity()).toList(),
    );
  }
}

extension SofParkirResultMapper on SofParkirResultModel {
  SofParkirResultEntity toEntity() {
    return SofParkirResultEntity(
      sof: sof,
      nominalMotor: nominalMotor,
      nominalMobil: nominalMobil,
      nominalBersihUntukWajibPajakMotor: nominalBersihUntukWajibPajakMotor,
      nominalBersihUntukWajibPajakMobil: nominalBersihUntukWajibPajakMobil,
      nominalBersihUntukBapendaMotor: nominalBersihUntukBapendaMotor,
      nominalBersihUntukBapendaMobil: nominalBersihUntukBapendaMobil,
      jumlahMotor: jumlahMotor,
      jumlahMobil: jumlahMobil,
    );
  }
}
