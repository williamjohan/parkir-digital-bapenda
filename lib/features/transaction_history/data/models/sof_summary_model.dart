import 'package:json_annotation/json_annotation.dart';

part 'sof_summary_model.g.dart';

@JsonSerializable()
class SofSummaryModel {
  @JsonKey(name: 'sof', defaultValue: '-')
  final String sof;

  @JsonKey(name: 'nominalMotor', defaultValue: 0)
  final int nominalMotor;

  @JsonKey(name: 'nominalMobil', defaultValue: 0)
  final int nominalMobil;

  @JsonKey(name: 'nominalBersihUntukWajibPajakMotor', defaultValue: 0.0)
  final double nominalBersihWajibPajakMotor;

  @JsonKey(name: 'nominalBersihUntukWajibPajakMobil', defaultValue: 0.0)
  final double nominalBersihWajibPajakMobil;

  @JsonKey(name: 'nominalBersihUntukBapendaMotor', defaultValue: 0.0)
  final double nominalBersihBapendaMotor;

  @JsonKey(name: 'nominalBersihUntukBapendaMobil', defaultValue: 0.0)
  final double nominalBersihBapendaMobil;

  @JsonKey(name: 'jumlahMotor', defaultValue: 0)
  final int jumlahMotor;

  @JsonKey(name: 'jumlahMobil', defaultValue: 0)
  final int jumlahMobil;

  SofSummaryModel({
    required this.sof,
    required this.nominalMotor,
    required this.nominalMobil,
    required this.nominalBersihWajibPajakMotor,
    required this.nominalBersihWajibPajakMobil,
    required this.nominalBersihBapendaMotor,
    required this.nominalBersihBapendaMobil,
    required this.jumlahMotor,
    required this.jumlahMobil,
  });

  int get totalTransaksi => jumlahMotor + jumlahMobil;
  int get totalNominal => nominalMotor + nominalMobil;

  int transaksiFor(String kategori) {
    switch (kategori) {
      case 'MOTOR':
        return jumlahMotor;
      case 'MOBIL':
        return jumlahMobil;
      default:
        return jumlahMotor + jumlahMobil;
    }
  }

  int nominalFor(String kategori) {
    switch (kategori) {
      case 'MOTOR':
        return nominalMotor;
      case 'MOBIL':
        return nominalMobil;
      default:
        return nominalMotor + nominalMobil;
    }
  }

  factory SofSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$SofSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SofSummaryModelToJson(this);
}
