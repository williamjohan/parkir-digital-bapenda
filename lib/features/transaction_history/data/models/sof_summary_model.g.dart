// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sof_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SofSummaryModel _$SofSummaryModelFromJson(
  Map<String, dynamic> json,
) => SofSummaryModel(
  sof: json['sof'] as String? ?? '-',
  nominalMotor: (json['nominalMotor'] as num?)?.toInt() ?? 0,
  nominalMobil: (json['nominalMobil'] as num?)?.toInt() ?? 0,
  nominalBersihWajibPajakMotor:
      (json['nominalBersihUntukWajibPajakMotor'] as num?)?.toDouble() ?? 0.0,
  nominalBersihWajibPajakMobil:
      (json['nominalBersihUntukWajibPajakMobil'] as num?)?.toDouble() ?? 0.0,
  nominalBersihBapendaMotor:
      (json['nominalBersihUntukBapendaMotor'] as num?)?.toDouble() ?? 0.0,
  nominalBersihBapendaMobil:
      (json['nominalBersihUntukBapendaMobil'] as num?)?.toDouble() ?? 0.0,
  jumlahMotor: (json['jumlahMotor'] as num?)?.toInt() ?? 0,
  jumlahMobil: (json['jumlahMobil'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SofSummaryModelToJson(
  SofSummaryModel instance,
) => <String, dynamic>{
  'sof': instance.sof,
  'nominalMotor': instance.nominalMotor,
  'nominalMobil': instance.nominalMobil,
  'nominalBersihUntukWajibPajakMotor': instance.nominalBersihWajibPajakMotor,
  'nominalBersihUntukWajibPajakMobil': instance.nominalBersihWajibPajakMobil,
  'nominalBersihUntukBapendaMotor': instance.nominalBersihBapendaMotor,
  'nominalBersihUntukBapendaMobil': instance.nominalBersihBapendaMobil,
  'jumlahMotor': instance.jumlahMotor,
  'jumlahMobil': instance.jumlahMobil,
};
