// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_jukir_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardSummaryJukirModel _$DashboardSummaryJukirModelFromJson(
  Map<String, dynamic> json,
) => DashboardSummaryJukirModel(
  jumlahMotorHariIni: (json['jumlahMotorHariIni'] as num?)?.toInt() ?? 0,
  jumlahMobilHariIni: (json['jumlahMobilHariIni'] as num?)?.toInt() ?? 0,
  totalNominalHariIni: _toDouble(json['totalNominalHariIni']),
  totalNominalBersihUntukWajibPajak: _toDouble(
    json['totalNominalBersihUntukWajibPajak'],
  ),
  totalNominalBersihUntukBapenda: _toDouble(
    json['totalNominalBersihUntukBapenda'],
  ),
);

Map<String, dynamic> _$DashboardSummaryJukirModelToJson(
  DashboardSummaryJukirModel instance,
) => <String, dynamic>{
  'jumlahMotorHariIni': instance.jumlahMotorHariIni,
  'jumlahMobilHariIni': instance.jumlahMobilHariIni,
  'totalNominalHariIni': instance.totalNominalHariIni,
  'totalNominalBersihUntukWajibPajak':
      instance.totalNominalBersihUntukWajibPajak,
  'totalNominalBersihUntukBapenda': instance.totalNominalBersihUntukBapenda,
};
