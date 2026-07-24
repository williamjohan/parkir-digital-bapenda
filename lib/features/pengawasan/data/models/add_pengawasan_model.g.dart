// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_pengawasan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPengawasanModel _$AddPengawasanModelFromJson(Map<String, dynamic> json) =>
    AddPengawasanModel(
      jenisPel: (json['JenisPel'] as num).toInt(),
      ketPel: json['KetPel'] as String,
      nomorObjek: json['NomorObjek'] as String,
      shift: (json['Shift'] as num).toInt(),
      jenis: (json['Jenis'] as num).toInt(),
    );

Map<String, dynamic> _$AddPengawasanModelToJson(AddPengawasanModel instance) =>
    <String, dynamic>{
      'JenisPel': instance.jenisPel,
      'KetPel': instance.ketPel,
      'NomorObjek': instance.nomorObjek,
      'Shift': instance.shift,
      'Jenis': instance.jenis,
    };
