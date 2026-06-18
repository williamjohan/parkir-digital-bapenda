// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_nonJukir_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardSummaryNonJukirModel _$DashboardSummaryNonJukirModelFromJson(
  Map<String, dynamic> json,
) => DashboardSummaryNonJukirModel(
  totalOp: (json['totalOp'] as num?)?.toInt() ?? 0,
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
  'jumlahMotorHariIni': instance.jumlahMotorHariIni,
  'jumlahMobilHariIni': instance.jumlahMobilHariIni,
  'totalNominalHariIni': instance.totalNominalHariIni,
  'totalNominalBersihUntukWajibPajak':
      instance.totalNominalBersihUntukWajibPajak,
  'totalNominalBersihUntukBapenda': instance.totalNominalBersihUntukBapenda,
  'sofParkirResults': instance.sofParkirResults,
};

SofParkirResultModel _$SofParkirResultModelFromJson(
  Map<String, dynamic> json,
) => SofParkirResultModel(
  sof: json['sof'] as String,
  nominalMotor: _toDouble(json['nominalMotor']),
  nominalMobil: _toDouble(json['nominalMobil']),
  nominalBersihUntukWajibPajakMotor: _toDouble(
    json['nominalBersihUntukWajibPajakMotor'],
  ),
  nominalBersihUntukWajibPajakMobil: _toDouble(
    json['nominalBersihUntukWajibPajakMobil'],
  ),
  nominalBersihUntukBapendaMotor: _toDouble(
    json['nominalBersihUntukBapendaMotor'],
  ),
  nominalBersihUntukBapendaMobil: _toDouble(
    json['nominalBersihUntukBapendaMobil'],
  ),
  jumlahMotor: (json['jumlahMotor'] as num?)?.toInt() ?? 0,
  jumlahMobil: (json['jumlahMobil'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SofParkirResultModelToJson(
  SofParkirResultModel instance,
) => <String, dynamic>{
  'sof': instance.sof,
  'nominalMotor': instance.nominalMotor,
  'nominalMobil': instance.nominalMobil,
  'nominalBersihUntukWajibPajakMotor':
      instance.nominalBersihUntukWajibPajakMotor,
  'nominalBersihUntukWajibPajakMobil':
      instance.nominalBersihUntukWajibPajakMobil,
  'nominalBersihUntukBapendaMotor': instance.nominalBersihUntukBapendaMotor,
  'nominalBersihUntukBapendaMobil': instance.nominalBersihUntukBapendaMobil,
  'jumlahMotor': instance.jumlahMotor,
  'jumlahMobil': instance.jumlahMobil,
};
