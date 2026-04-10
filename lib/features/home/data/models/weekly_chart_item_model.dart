import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weekly_chart_item_model.g.dart';

double _toDouble(dynamic value) => (value ?? 0).toDouble();

@JsonSerializable()
class WeeklyChartItemModel extends Equatable {
  final DateTime tgl;

  @JsonKey(defaultValue: 0)
  final int motor;

  @JsonKey(defaultValue: 0)
  final int mobil;

  @JsonKey(fromJson: _toDouble)
  final double total;

  const WeeklyChartItemModel({
    required this.tgl,
    required this.motor,
    required this.mobil,
    required this.total,
  });

  factory WeeklyChartItemModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyChartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyChartItemModelToJson(this);

  @override
  List<Object?> get props => [tgl, motor, mobil, total];
}
