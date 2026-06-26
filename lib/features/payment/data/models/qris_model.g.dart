// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qris_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrisModel _$QrisModelFromJson(Map<String, dynamic> json) => QrisModel(
  kodeQris: json['kodeQris'] as String,
  qrisValue: json['qrisValue'] as String,
  qrisBase64: json['qrisBase64'] as String,
  nmid: json['nmid'] as String,
  nameQris: json['nameQris'] as String,
  nominal: (json['nominal'] as num).toInt(),
  expTimeMenit: (json['expTimeMenit'] as num).toInt(),
);

Map<String, dynamic> _$QrisModelToJson(QrisModel instance) => <String, dynamic>{
  'kodeQris': instance.kodeQris,
  'qrisValue': instance.qrisValue,
  'qrisBase64': instance.qrisBase64,
  'nmid': instance.nmid,
  'nameQris': instance.nameQris,
  'nominal': instance.nominal,
  'expTimeMenit': instance.expTimeMenit,
};
