// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardSummaryModel _$DashboardSummaryModelFromJson(
  Map<String, dynamic> json,
) => DashboardSummaryModel(
  jumlahMotorHariIni: (json['jumlahMotorHariIni'] as num?)?.toInt() ?? 0,
  jumlahMobilHariIni: (json['jumlahMobilHariIni'] as num?)?.toInt() ?? 0,
  totalNominalHariIni: _toDouble(json['totalNominalHariIni']),
);

Map<String, dynamic> _$DashboardSummaryModelToJson(
  DashboardSummaryModel instance,
) => <String, dynamic>{
  'jumlahMotorHariIni': instance.jumlahMotorHariIni,
  'jumlahMobilHariIni': instance.jumlahMobilHariIni,
  'totalNominalHariIni': instance.totalNominalHariIni,
};
