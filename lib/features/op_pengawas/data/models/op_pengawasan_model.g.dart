// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'op_pengawasan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpPengawasanModel _$OpPengawasanModelFromJson(Map<String, dynamic> json) =>
    OpPengawasanModel(
      idTempat: json['idTempat'] as String,
      namaTempat: json['namaTempat'] as String,
      alamatTempat: json['alamatTempat'] as String,
      kdCamat: json['kdCamat'] as String,
      nmCamat: json['nmCamat'] as String,
      jenis: (json['jenis'] as num).toInt(),
    );

Map<String, dynamic> _$OpPengawasanModelToJson(OpPengawasanModel instance) =>
    <String, dynamic>{
      'idTempat': instance.idTempat,
      'namaTempat': instance.namaTempat,
      'alamatTempat': instance.alamatTempat,
      'kdCamat': instance.kdCamat,
      'nmCamat': instance.nmCamat,
      'jenis': instance.jenis,
    };
