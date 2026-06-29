// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daftar_nop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DaftarNopModelImpl _$$DaftarNopModelImplFromJson(Map<String, dynamic> json) =>
    _$DaftarNopModelImpl(
      nop: json['nop'] as String,
      namaOp: json['namaOp'] as String,
      alamatOp: json['alamatOp'] as String,
      isDigital: json['isDigital'] as bool,
      pungutTarif: (json['pungutTarif'] as num).toInt(),
      uptb: (json['uptb'] as num).toInt(),
      totalPendapatan: (json['totalPendapatan'] as num).toInt(),
      kdCamat: json['kdCamat'] as String? ?? '',
      nmCamat: json['nmCamat'] as String? ?? '',
      kdLurah: json['kdLurah'] as String? ?? '',
      nmLurah: json['nmLurah'] as String? ?? '',
    );

Map<String, dynamic> _$$DaftarNopModelImplToJson(
  _$DaftarNopModelImpl instance,
) => <String, dynamic>{
  'nop': instance.nop,
  'namaOp': instance.namaOp,
  'alamatOp': instance.alamatOp,
  'isDigital': instance.isDigital,
  'pungutTarif': instance.pungutTarif,
  'uptb': instance.uptb,
  'totalPendapatan': instance.totalPendapatan,
  'kdCamat': instance.kdCamat,
  'nmCamat': instance.nmCamat,
  'kdLurah': instance.kdLurah,
  'nmLurah': instance.nmLurah,
};
