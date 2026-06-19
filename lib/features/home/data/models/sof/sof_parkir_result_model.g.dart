// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sof_parkir_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
