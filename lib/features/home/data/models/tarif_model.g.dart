// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarif_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TarifModel _$TarifModelFromJson(Map<String, dynamic> json) => TarifModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  jenisTarif: json['jenisTarif'] as String? ?? '',
  tarif: _toDouble(json['tarif']),
);

Map<String, dynamic> _$TarifModelToJson(TarifModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jenisTarif': instance.jenisTarif,
      'tarif': instance.tarif,
    };
