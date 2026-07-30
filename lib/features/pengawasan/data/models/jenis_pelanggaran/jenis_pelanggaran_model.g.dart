// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jenis_pelanggaran_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JenisPelanggaranModel _$JenisPelanggaranModelFromJson(
  Map<String, dynamic> json,
) => JenisPelanggaranModel(
  id: (json['id'] as num).toInt(),
  namaPelanggaran: json['nama'] as String,
  jenis: (json['jenis'] as num).toInt(),
);

Map<String, dynamic> _$JenisPelanggaranModelToJson(
  JenisPelanggaranModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.namaPelanggaran,
  'jenis': instance.jenis,
};
