import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary_non_jukir_entity.freezed.dart';

@freezed
class DashboardSummaryNonJukirEntity with _$DashboardSummaryNonJukirEntity {
  const factory DashboardSummaryNonJukirEntity({
    required int totalOp,
    required int totalOpDigital,
    required int totalOpNonDigital,
    required int totalOpFree,
    required int jumlahMotorHariIni,
    required int jumlahMobilHariIni,
    required double totalNominalHariIni,
    required double totalNominalBersihUntukWajibPajak,
    required double totalNominalBersihUntukBapenda,
    required List<SofParkirResultEntity> sofParkirResults,
  }) = _DashboardSummaryNonJukirEntity;
}

@freezed
class SofParkirResultEntity with _$SofParkirResultEntity {
  const factory SofParkirResultEntity({
    required String sof,
    required double nominalMotor,
    required double nominalMobil,
    required double nominalBersihUntukWajibPajakMotor,
    required double nominalBersihUntukWajibPajakMobil,
    required double nominalBersihUntukBapendaMotor,
    required double nominalBersihUntukBapendaMobil,
    required int jumlahMotor,
    required int jumlahMobil,
  }) = _SofParkirResultEntity;
}
