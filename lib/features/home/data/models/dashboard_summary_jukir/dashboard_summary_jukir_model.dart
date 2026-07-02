import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_summary_jukir_model.g.dart';

double _toDouble(dynamic value) => (value ?? 0).toDouble();

@JsonSerializable()
class DashboardSummaryJukirModel extends Equatable {
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

  const DashboardSummaryJukirModel({
    required this.jumlahMotorHariIni,
    required this.jumlahMobilHariIni,
    required this.totalNominalHariIni,
    required this.totalNominalBersihUntukWajibPajak,
    required this.totalNominalBersihUntukBapenda,
  });

  factory DashboardSummaryJukirModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryJukirModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryJukirModelToJson(this);

  @override
  List<Object?> get props => [
    jumlahMotorHariIni,
    jumlahMobilHariIni,
    totalNominalHariIni,
    totalNominalBersihUntukWajibPajak,
    totalNominalBersihUntukBapenda,
  ];
}
