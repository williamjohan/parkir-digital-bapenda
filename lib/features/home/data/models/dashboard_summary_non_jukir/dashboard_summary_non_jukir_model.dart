// lib/features/home/data/models/dashboard_summary_non_jukir_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary_non_jukir_model.freezed.dart';
part 'dashboard_summary_non_jukir_model.g.dart';

@freezed
class DashboardSummaryNonJukirModel with _$DashboardSummaryNonJukirModel {
  const factory DashboardSummaryNonJukirModel({
    @Default(0) int totalOp,
    @Default(0) int totalOpDigital,
    @Default(0) int totalOpNonDigital,
    @Default(0) int jumlahMotorHariIni,
    @Default(0) int jumlahMobilHariIni,
    @Default(0) int totalBertarif,
    @Default(0) int totalNonTarif,
    @Default(0) int totalTarifTidakDiketahui,
    @Default(0.0) double totalNominalHariIni,
    @Default(0.0) double totalNominalBersihUntukWajibPajak,
    @Default(0.0) double totalNominalBersihUntukBapenda,
    @Default([]) List<SofParkirResultModel> sofParkirResults,
    @Default(OpCategoryModel()) OpCategoryModel digital,
    @Default(OpCategoryModel()) OpCategoryModel nonDigital,

    @Default(0.0) double persentaseDigital,
    @Default(0.0) double persentaseNonDigital,
  }) = _DashboardSummaryNonJukirModel;

  factory DashboardSummaryNonJukirModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryNonJukirModelFromJson(json);
}

@freezed
class SofParkirResultModel with _$SofParkirResultModel {
  const factory SofParkirResultModel({
    @Default('') String sof,
    @Default(0.0) double nominalMotor,
    @Default(0.0) double nominalMobil,
    @Default(0.0) double nominalBersihUntukWajibPajakMotor,
    @Default(0.0) double nominalBersihUntukWajibPajakMobil,
    @Default(0.0) double nominalBersihUntukBapendaMotor,
    @Default(0.0) double nominalBersihUntukBapendaMobil,
    @Default(0) int jumlahMotor,
    @Default(0) int jumlahMobil,
  }) = _SofParkirResultModel;

  factory SofParkirResultModel.fromJson(Map<String, dynamic> json) =>
      _$SofParkirResultModelFromJson(json);
}

@freezed
class OpCategoryModel with _$OpCategoryModel {
  const factory OpCategoryModel({
    @Default(0) int total,
    @Default(0) int totalBertarif,
    @Default(0) int totalNonTarif,
    @Default(0) int totalTidakDiketahui,
    @Default(0.0) double persentaseBertarif,
    @Default(0.0) double persentaseNonTarif,
    @Default(0.0) double persentaseTidakDiketahui,
  }) = _OpCategoryModel;

  factory OpCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$OpCategoryModelFromJson(json);
}
