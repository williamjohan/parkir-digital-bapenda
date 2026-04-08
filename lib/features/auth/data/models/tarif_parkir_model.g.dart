// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarif_parkir_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TarifParkirModel _$TarifParkirModelFromJson(Map<String, dynamic> json) =>
    TarifParkirModel(
      jenisTarif: _toString(json['jenisTarif']),
      tarif: _toInt(json['tarif']),
    );

Map<String, dynamic> _$TarifParkirModelToJson(TarifParkirModel instance) =>
    <String, dynamic>{
      'jenisTarif': instance.jenisTarif,
      'tarif': instance.tarif,
    };
