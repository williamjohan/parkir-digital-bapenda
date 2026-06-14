import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_summary_model.g.dart';

//helper untuk memastikan semua nilai numerik yang mungkin datang sebagai null
//atau string bisa diubah menjadi double dengan aman
double _toDouble(dynamic value) => (value ?? 0).toDouble();

@JsonSerializable()
class DashboardSummaryModel extends Equatable {
  @JsonKey(defaultValue: 0)
  final int jumlahMotorHariIni;

  @JsonKey(defaultValue: 0)
  final int jumlahMobilHariIni;

  @JsonKey(fromJson: _toDouble)
  final double totalNominalHariIni;

  // 🚀 PENAMBAHAN FIELD BARU (Dilindungi dengan _toDouble)
  @JsonKey(fromJson: _toDouble)
  final double totalNominalBersihUntukWajibPajak;

  @JsonKey(fromJson: _toDouble)
  final double totalNominalBersihUntukBapenda;

  const DashboardSummaryModel({
    required this.jumlahMotorHariIni,
    required this.jumlahMobilHariIni,
    required this.totalNominalHariIni,
    required this.totalNominalBersihUntukWajibPajak,
    required this.totalNominalBersihUntukBapenda,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryModelToJson(this);

  @override
  List<Object?> get props => [
    jumlahMotorHariIni,
    jumlahMobilHariIni,
    totalNominalHariIni,
    totalNominalBersihUntukWajibPajak,
    totalNominalBersihUntukBapenda,
  ];
}
