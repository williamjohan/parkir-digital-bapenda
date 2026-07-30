import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';

part 'laporan_pengawasan_model.g.dart';

@JsonSerializable()
class LaporanPengawasanModel {
  @JsonKey(name: 'idEvent')
  final int idEvent;

  @JsonKey(name: 'nip')
  final String nip;

  @JsonKey(name: 'opd')
  final String opd;

  @JsonKey(name: 'kdCamat')
  final String kdCamat;

  @JsonKey(name: 'nmCamat')
  final String nmCamat;

  @JsonKey(name: 'kdOp')
  final String kdOp;

  @JsonKey(name: 'nmOp')
  final String nmOp;

  @JsonKey(name: 'jenis')
  final int jenis;

  @JsonKey(name: 'shift')
  final int shift;

  @JsonKey(name: 'tglPengawasan')
  final DateTime tglPengawasan;

  @JsonKey(name: 'seq')
  final int seq;

  @JsonKey(name: 'jenisPel')
  final int jenisPel;

  @JsonKey(name: 'ketPel')
  final String ketPel;

  @JsonKey(name: 'insDate')
  final DateTime insDate;

  @JsonKey(name: 'insBy')
  final String insBy;

  @JsonKey(name: 'fotoPelaporan')
  final String? fotoPelaporan;

  const LaporanPengawasanModel({
    required this.idEvent,
    required this.nip,
    required this.opd,
    required this.kdCamat,
    required this.nmCamat,
    required this.kdOp,
    required this.nmOp,
    required this.jenis,
    required this.shift,
    required this.tglPengawasan,
    required this.seq,
    required this.jenisPel,
    required this.ketPel,
    required this.insDate,
    required this.insBy,
    this.fotoPelaporan,
  });

  factory LaporanPengawasanModel.fromJson(Map<String, dynamic> json) =>
      _$LaporanPengawasanModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaporanPengawasanModelToJson(this);
}

extension LaporanPengawasanModelExt on LaporanPengawasanModel {
  LaporanPengawasanEntity toEntity() {
    return LaporanPengawasanEntity(
      idEvent: idEvent,
      nip: nip,
      opd: opd,
      kdCamat: kdCamat,
      nmCamat: nmCamat,
      kdOp: kdOp,
      nmOp: nmOp,
      jenis: jenis,
      shift: shift,
      tglPengawasan: tglPengawasan,
      seq: seq,
      jenisPel: jenisPel,
      ketPel: ketPel,
      insDate: insDate,
      insBy: insBy,
      fotoPelaporan: fotoPelaporan,
    );
  }
}
