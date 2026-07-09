import 'package:json_annotation/json_annotation.dart';

part 'laporan_pengawasan_model.g.dart';

@JsonSerializable()
class LaporanPengawasanModel {
  @JsonKey(name: 'idEvent')
  final int idEvent;

  @JsonKey(name: 'op')
  final String op;

  @JsonKey(name: 'nip')
  final String nip;

  @JsonKey(name: 'tglRoster')
  final DateTime tglRoster;

  @JsonKey(name: 'jadwalMasuk')
  final DateTime jadwalMasuk;

  @JsonKey(name: 'jenisPel')
  final int jenisPel;

  @JsonKey(name: 'ketPel')
  final String ketPel;

  @JsonKey(name: 'insDate')
  final DateTime insDate;

  @JsonKey(name: 'insBy')
  final String insBy;

  @JsonKey(name: 'seq')
  final int seq;

  @JsonKey(name: 'fotoPelaporan')
  final String? fotoPelaporan;

  const LaporanPengawasanModel({
    required this.idEvent,
    required this.op,
    required this.nip,
    required this.tglRoster,
    required this.jadwalMasuk,
    required this.jenisPel,
    required this.ketPel,
    required this.insDate,
    required this.insBy,
    required this.seq,
    this.fotoPelaporan,
  });

  factory LaporanPengawasanModel.fromJson(Map<String, dynamic> json) =>
      _$LaporanPengawasanModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaporanPengawasanModelToJson(this);
}
