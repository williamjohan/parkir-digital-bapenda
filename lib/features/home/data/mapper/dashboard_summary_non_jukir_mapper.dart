import 'package:parkir_digital_bapenda/features/home/data/models/dashboard_summary_non_jukir/dashboard_summary_non_jukir_model.dart';
import 'package:parkir_digital_bapenda/features/home/domain/entities/dashboard_summary_non_jukir_entity.dart';

extension DashboardSummaryNonJukirMapper on DashboardSummaryNonJukirModel {
  DashboardSummaryNonJukirEntity toEntity() {
    return DashboardSummaryNonJukirEntity(
      totalOp: totalOp,
      totalOpDigital: totalOpDigital,
      totalOpNonDigital: totalOpNonDigital,
      totalOpFree: totalNonTarif,
      totalOpNonFree: totalBertarif,
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
