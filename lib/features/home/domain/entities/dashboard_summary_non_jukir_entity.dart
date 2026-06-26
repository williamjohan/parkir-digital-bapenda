import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary_non_jukir_entity.freezed.dart';

@freezed
class DashboardSummaryNonJukirEntity with _$DashboardSummaryNonJukirEntity {
  const factory DashboardSummaryNonJukirEntity({
    required int totalOp,
    required int totalOpDigital,
    required int totalOpNonDigital,
    required int totalBertarif,
    required int totalNonTarif,
    required int totalTarifTidakDiketahui,

    required int totalOpFree,
    required int totalOpNonFree,

    required int jumlahMotorHariIni,
    required int jumlahMobilHariIni,

    required double totalNominalHariIni,
    required double totalNominalBersihUntukWajibPajak,
    required double totalNominalBersihUntukBapenda,

    required List<SofParkirResultEntity> sofParkirResults,

    required OpCategoryEntity digital,
    required OpCategoryEntity nonDigital,

    required DetailEntity detail,
    required BerbayarEntity berbayar,

    required double persentaseDigital,
    required double persentaseNonDigital,
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

@freezed
class OpCategoryEntity with _$OpCategoryEntity {
  const factory OpCategoryEntity({
    required int total,
    required int totalBertarif,
    required int totalNonTarif,
    required int totalTidakDiketahui,
    required double persentaseBertarif,
    required double persentaseNonTarif,
    required double persentaseTidakDiketahui,
  }) = _OpCategoryEntity;
}

@freezed
class DetailEntity with _$DetailEntity {
  const factory DetailEntity({
    required int totalEdc,
    required int totalRompiQris,
    required int totalCctvCounting,
    required int totalTs,
    required int totalBebasParkir,
    required int totalNonDigital,
  }) = _DetailEntity;
}

@freezed
class BerbayarEntity with _$BerbayarEntity {
  const factory BerbayarEntity({
    required int digital,
    required int nonDigital,
    required int total,
    required double persentase,
  }) = _BerbayarEntity;
}
