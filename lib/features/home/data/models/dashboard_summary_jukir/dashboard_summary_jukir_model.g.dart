// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_jukir_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardSummaryJukirModelImpl _$$DashboardSummaryJukirModelImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardSummaryJukirModelImpl(
  jumlahMotorHariIni: (json['jumlahMotorHariIni'] as num?)?.toInt() ?? 0,
  jumlahMobilHariIni: (json['jumlahMobilHariIni'] as num?)?.toInt() ?? 0,
  totalNominalHariIni: json['totalNominalHariIni'] == null
      ? 0.0
      : _toDouble(json['totalNominalHariIni']),
  totalNominalBersihUntukWajibPajak:
      json['totalNominalBersihUntukWajibPajak'] == null
      ? 0.0
      : _toDouble(json['totalNominalBersihUntukWajibPajak']),
  totalNominalBersihUntukBapenda: json['totalNominalBersihUntukBapenda'] == null
      ? 0.0
      : _toDouble(json['totalNominalBersihUntukBapenda']),
);

Map<String, dynamic> _$$DashboardSummaryJukirModelImplToJson(
  _$DashboardSummaryJukirModelImpl instance,
) => <String, dynamic>{
  'jumlahMotorHariIni': instance.jumlahMotorHariIni,
  'jumlahMobilHariIni': instance.jumlahMobilHariIni,
  'totalNominalHariIni': instance.totalNominalHariIni,
  'totalNominalBersihUntukWajibPajak':
      instance.totalNominalBersihUntukWajibPajak,
  'totalNominalBersihUntukBapenda': instance.totalNominalBersihUntukBapenda,
};
