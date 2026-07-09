// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/dashboard_summary_jukir_entity.dart';

part 'dashboard_summary_jukir_model.freezed.dart';
part 'dashboard_summary_jukir_model.g.dart';

double _toDouble(dynamic value) => (value ?? 0).toDouble();

@freezed
class DashboardSummaryJukirModel with _$DashboardSummaryJukirModel {
  const factory DashboardSummaryJukirModel({
    @Default(0) int jumlahMotorHariIni,
    @Default(0) int jumlahMobilHariIni,
    @JsonKey(fromJson: _toDouble) @Default(0.0) double totalNominalHariIni,
    @JsonKey(fromJson: _toDouble)
    @Default(0.0)
    double totalNominalBersihUntukWajibPajak,
    @JsonKey(fromJson: _toDouble)
    @Default(0.0)
    double totalNominalBersihUntukBapenda,
  }) = _DashboardSummaryJukirModel;

  factory DashboardSummaryJukirModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryJukirModelFromJson(json);
}

// Extension tetap aman berada di luar class
extension DashboardSummaryJukirModelX on DashboardSummaryJukirModel {
  DashboardSummaryJukirEntity toEntity() {
    return DashboardSummaryJukirEntity(
      jumlahMotorHariIni: jumlahMotorHariIni,
      jumlahMobilHariIni: jumlahMobilHariIni,
      totalNominalHariIni: totalNominalHariIni,
      totalNominalBersihUntukWajibPajak: totalNominalBersihUntukWajibPajak,
      totalNominalBersihUntukBapenda: totalNominalBersihUntukBapenda,
    );
  }
}
