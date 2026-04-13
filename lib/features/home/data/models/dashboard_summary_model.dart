import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_summary_model.g.dart';

double _toDouble(dynamic value) => (value ?? 0).toDouble();

@JsonSerializable()
class DashboardSummaryModel extends Equatable {
  @JsonKey(defaultValue: 0)
  final int jumlahMotorHariIni;

  @JsonKey(defaultValue: 0)
  final int jumlahMobilHariIni;

  @JsonKey(fromJson: _toDouble)
  final double totalNominalHariIni;

  const DashboardSummaryModel({
    required this.jumlahMotorHariIni,
    required this.jumlahMobilHariIni,
    required this.totalNominalHariIni,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryModelToJson(this);

  @override
  List<Object?> get props => [
    jumlahMotorHariIni,
    jumlahMobilHariIni,
    totalNominalHariIni,
  ];
}
