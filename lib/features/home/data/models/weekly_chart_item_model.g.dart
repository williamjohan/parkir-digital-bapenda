part of 'weekly_chart_item_model.dart';

WeeklyChartItemModel _$WeeklyChartItemModelFromJson(
  Map<String, dynamic> json,
) => WeeklyChartItemModel(
  tgl: DateTime.parse(json['tgl'] as String),
  hari: json['hari'] as String,
  motor: (json['motor'] as num?)?.toInt() ?? 0,
  mobil: (json['mobil'] as num?)?.toInt() ?? 0,
  nominalTotal: _toDouble(json['nominalTotal']),
  nominalMotor: _toDouble(json['nominalMotor']),
  nominalMobil: _toDouble(json['nominalMobil']),
);

Map<String, dynamic> _$WeeklyChartItemModelToJson(
  WeeklyChartItemModel instance,
) => <String, dynamic>{
  'tgl': instance.tgl.toIso8601String(),
  'hari': instance.hari,
  'motor': instance.motor,
  'mobil': instance.mobil,
  'nominalTotal': instance.nominalTotal,
  'nominalMotor': instance.nominalMotor,
  'nominalMobil': instance.nominalMobil,
};
