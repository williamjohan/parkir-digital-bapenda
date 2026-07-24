// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alat_digital_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlatDigitalModelImpl _$$AlatDigitalModelImplFromJson(
  Map<String, dynamic> json,
) => _$AlatDigitalModelImpl(
  id: (json['id'] as num?)?.toInt() ?? 0,
  nama: json['nama'] as String? ?? '',
  jenis: (json['jenis'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$AlatDigitalModelImplToJson(
  _$AlatDigitalModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.nama,
  'jenis': instance.jenis,
};
