// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_pengawasan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPengawasanModel _$AddPengawasanModelFromJson(Map<String, dynamic> json) =>
    AddPengawasanModel(
      jenisPel: (json['JenisPel'] as num).toInt(),
      ketPel: json['KetPel'] as String,
    );

Map<String, dynamic> _$AddPengawasanModelToJson(AddPengawasanModel instance) =>
    <String, dynamic>{'JenisPel': instance.jenisPel, 'KetPel': instance.ketPel};
