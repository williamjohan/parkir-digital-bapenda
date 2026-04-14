import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weekly_chart_item_model.g.dart';

double _toDouble(dynamic value) => (value ?? 0).toDouble();

@JsonSerializable()
class WeeklyChartItemModel extends Equatable {
  final DateTime tgl;

  final String hari;

  @JsonKey(defaultValue: 0)
  final int motor;

  @JsonKey(defaultValue: 0)
  final int mobil;

  @JsonKey(fromJson: _toDouble)
  final double nominalTotal;

  @JsonKey(fromJson: _toDouble)
  final double nominalMotor;

  @JsonKey(fromJson: _toDouble)
  final double nominalMobil;

  const WeeklyChartItemModel({
    required this.tgl,
    required this.hari,
    required this.motor,
    required this.mobil,
    required this.nominalTotal,
    required this.nominalMotor,
    required this.nominalMobil,
  });

  String get hariSingkat {
    switch (hari.toLowerCase()) {
      case 'senin':
        return 'Sen';
      case 'selasa':
        return 'Sel';
      case 'rabu':
        return 'Rab';
      case 'kamis':
        return 'Kam';
      case 'jumat':
        return 'Jum';
      case 'sabtu':
        return 'Sab';
      case 'minggu':
        return 'Min';
      default:
        return hari;
    }
  }

  factory WeeklyChartItemModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyChartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyChartItemModelToJson(this);

  @override
  List<Object?> get props => [
    tgl,
    hari,
    motor,
    mobil,
    nominalTotal,
    nominalMotor,
    nominalMobil,
  ];
}
