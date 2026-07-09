// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laporan_pengawasan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaporanPengawasanModel _$LaporanPengawasanModelFromJson(
  Map<String, dynamic> json,
) => LaporanPengawasanModel(
  idEvent: (json['idEvent'] as num).toInt(),
  op: json['op'] as String,
  nip: json['nip'] as String,
  tglRoster: DateTime.parse(json['tglRoster'] as String),
  jadwalMasuk: DateTime.parse(json['jadwalMasuk'] as String),
  jenisPel: (json['jenisPel'] as num).toInt(),
  ketPel: json['ketPel'] as String,
  insDate: DateTime.parse(json['insDate'] as String),
  insBy: json['insBy'] as String,
  seq: (json['seq'] as num).toInt(),
  fotoPelaporan: json['fotoPelaporan'] as String?,
);

Map<String, dynamic> _$LaporanPengawasanModelToJson(
  LaporanPengawasanModel instance,
) => <String, dynamic>{
  'idEvent': instance.idEvent,
  'op': instance.op,
  'nip': instance.nip,
  'tglRoster': instance.tglRoster.toIso8601String(),
  'jadwalMasuk': instance.jadwalMasuk.toIso8601String(),
  'jenisPel': instance.jenisPel,
  'ketPel': instance.ketPel,
  'insDate': instance.insDate.toIso8601String(),
  'insBy': instance.insBy,
  'seq': instance.seq,
  'fotoPelaporan': instance.fotoPelaporan,
};
