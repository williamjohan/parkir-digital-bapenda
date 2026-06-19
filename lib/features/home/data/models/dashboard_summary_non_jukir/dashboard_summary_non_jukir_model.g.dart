// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_non_jukir_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardSummaryNonJukirModel _$DashboardSummaryNonJukirModelFromJson(
  Map<String, dynamic> json,
) => DashboardSummaryNonJukirModel(
  totalOp: (json['totalOp'] as num?)?.toInt() ?? 0,
  totalOpDigital: (json['totalOpDigital'] as num?)?.toInt() ?? 0,
  totalOpNonDigital: (json['totalOpNonDigital'] as num?)?.toInt() ?? 0,
  jumlahMotorHariIni: (json['jumlahMotorHariIni'] as num?)?.toInt() ?? 0,
  jumlahMobilHariIni: (json['jumlahMobilHariIni'] as num?)?.toInt() ?? 0,
  totalNominalHariIni: _toDouble(json['totalNominalHariIni']),
  totalNominalBersihUntukWajibPajak: _toDouble(
    json['totalNominalBersihUntukWajibPajak'],
  ),
  totalNominalBersihUntukBapenda: _toDouble(
    json['totalNominalBersihUntukBapenda'],
  ),
  sofParkirResults:
      (json['sofParkirResults'] as List<dynamic>?)
          ?.map((e) => SofParkirResultModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$DashboardSummaryNonJukirModelToJson(
  DashboardSummaryNonJukirModel instance,
) => <String, dynamic>{
  'totalOp': instance.totalOp,
  'totalOpDigital': instance.totalOpDigital,
  'totalOpNonDigital': instance.totalOpNonDigital,
  'jumlahMotorHariIni': instance.jumlahMotorHariIni,
  'jumlahMobilHariIni': instance.jumlahMobilHariIni,
  'totalNominalHariIni': instance.totalNominalHariIni,
  'totalNominalBersihUntukWajibPajak':
      instance.totalNominalBersihUntukWajibPajak,
  'totalNominalBersihUntukBapenda': instance.totalNominalBersihUntukBapenda,
  'sofParkirResults': instance.sofParkirResults,
};
