import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../sof/sof_parkir_result_model.dart';

part 'dashboard_summary_non_jukir_model.g.dart';

double _toDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is double) return value;
  if (value is int) return value.toDouble();

  return double.tryParse(value.toString()) ?? 0.0;
}

@JsonSerializable()
class DashboardSummaryNonJukirModel extends Equatable {
  @JsonKey(defaultValue: 0)
  final int totalOp;

  @JsonKey(defaultValue: 0)
  final int jumlahMotorHariIni;

  @JsonKey(defaultValue: 0)
  final int jumlahMobilHariIni;

  @JsonKey(fromJson: _toDouble)
  final double totalNominalHariIni;

  @JsonKey(fromJson: _toDouble)
  final double totalNominalBersihUntukWajibPajak;

  @JsonKey(fromJson: _toDouble)
  final double totalNominalBersihUntukBapenda;

  @JsonKey(defaultValue: [])
  final List<SofParkirResultModel> sofParkirResults;

  const DashboardSummaryNonJukirModel({
    required this.totalOp,
    required this.jumlahMotorHariIni,
    required this.jumlahMobilHariIni,
    required this.totalNominalHariIni,
    required this.totalNominalBersihUntukWajibPajak,
    required this.totalNominalBersihUntukBapenda,
    required this.sofParkirResults,
  });

  factory DashboardSummaryNonJukirModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryNonJukirModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryNonJukirModelToJson(this);

  @override
  List<Object?> get props => [
    totalOp,
    jumlahMotorHariIni,
    jumlahMobilHariIni,
    totalNominalHariIni,
    totalNominalBersihUntukWajibPajak,
    totalNominalBersihUntukBapenda,
    sofParkirResults,
  ];
}
