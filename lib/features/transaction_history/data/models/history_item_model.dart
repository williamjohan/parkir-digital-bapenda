import 'package:json_annotation/json_annotation.dart';

part 'history_item_model.g.dart';

@JsonSerializable()
class HistoryItemModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'orderId', defaultValue: '')
  final String orderId;

  @JsonKey(name: 'jenisTarif', defaultValue: 'FREE')
  final String jenisTarif;

  @JsonKey(name: 'sof', defaultValue: 'FREE')
  final String sof;

  @JsonKey(name: 'platNumber', defaultValue: '-')
  final String platNumber;

  @JsonKey(name: 'tglTrx', defaultValue: '')
  final String tglTrx;

  @JsonKey(name: 'kredit', defaultValue: 0)
  final int kredit;

  @JsonKey(name: 'namaPetugas', defaultValue: '')
  final String namaPetugas;

  @JsonKey(name: 'modePlat', defaultValue: 0)
  final int modePlat;

  @JsonKey(name: 'shift', defaultValue: '-')
  final String shift;

  HistoryItemModel({
    required this.id,
    required this.orderId,
    required this.jenisTarif,
    required this.sof,
    required this.platNumber,
    required this.tglTrx,
    required this.kredit,
    required this.namaPetugas,
    required this.modePlat,
    required this.shift,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryItemModelFromJson(json);

  factory HistoryItemModel.fromLocalDatabase(Map<String, dynamic> map) {
    return HistoryItemModel(
      id: 0, // SQLite lokal tidak punya id dari server, pakai 0 sebagai sentinel
      orderId: map['id_transaksi_lokal']?.toString() ?? '',
      jenisTarif: map['kategori_kendaraan']?.toString() ?? '-',
      sof: map['metode_pembayaran']?.toString() ?? 'FREE',
      platNumber: map['plat_nomor']?.toString() ?? '-',
      tglTrx: map['waktu_transaksi']?.toString() ?? '',
      kredit: (map['nominal'] as num?)?.toInt() ?? 0,
      namaPetugas: map['nama_jukir']?.toString() ?? '',
      modePlat: (map['mode_plat'] as num?)?.toInt() ?? 0,
      shift: map['shift']?.toString() ?? '1',
    );
  }
}
