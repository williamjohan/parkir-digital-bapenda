// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laporan_pengawasan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaporanPengawasanModel _$LaporanPengawasanModelFromJson(
  Map<String, dynamic> json,
) => LaporanPengawasanModel(
  idEvent: (json['idEvent'] as num).toInt(),
  nip: json['nip'] as String,
  opd: json['opd'] as String,
  kdCamat: json['kdCamat'] as String,
  nmCamat: json['nmCamat'] as String,
  kdOp: json['kdOp'] as String,
  nmOp: json['nmOp'] as String,
  jenis: (json['jenis'] as num).toInt(),
  shift: (json['shift'] as num).toInt(),
  tglPengawasan: DateTime.parse(json['tglPengawasan'] as String),
  seq: (json['seq'] as num).toInt(),
  jenisPel: (json['jenisPel'] as num).toInt(),
  ketPel: json['ketPel'] as String,
  insDate: DateTime.parse(json['insDate'] as String),
  insBy: json['insBy'] as String,
  fotoPelaporan: json['fotoPelaporan'] as String?,
);

Map<String, dynamic> _$LaporanPengawasanModelToJson(
  LaporanPengawasanModel instance,
) => <String, dynamic>{
  'idEvent': instance.idEvent,
  'nip': instance.nip,
  'opd': instance.opd,
  'kdCamat': instance.kdCamat,
  'nmCamat': instance.nmCamat,
  'kdOp': instance.kdOp,
  'nmOp': instance.nmOp,
  'jenis': instance.jenis,
  'shift': instance.shift,
  'tglPengawasan': instance.tglPengawasan.toIso8601String(),
  'seq': instance.seq,
  'jenisPel': instance.jenisPel,
  'ketPel': instance.ketPel,
  'insDate': instance.insDate.toIso8601String(),
  'insBy': instance.insBy,
  'fotoPelaporan': instance.fotoPelaporan,
};
