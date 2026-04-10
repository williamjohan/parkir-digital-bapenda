// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_chart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyChartItemModel _$WeeklyChartItemModelFromJson(
  Map<String, dynamic> json,
) => WeeklyChartItemModel(
  tgl: DateTime.parse(json['tgl'] as String),
  motor: (json['motor'] as num?)?.toInt() ?? 0,
  mobil: (json['mobil'] as num?)?.toInt() ?? 0,
  total: _toDouble(json['total']),
);

Map<String, dynamic> _$WeeklyChartItemModelToJson(
  WeeklyChartItemModel instance,
) => <String, dynamic>{
  'tgl': instance.tgl.toIso8601String(),
  'motor': instance.motor,
  'mobil': instance.mobil,
  'total': instance.total,
};
