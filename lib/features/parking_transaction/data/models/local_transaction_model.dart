// lib/features/parking_transaction/data/models/local_transaction_model.dart

import 'package:json_annotation/json_annotation.dart';

import '../../../transaction_history/data/models/history_item_model.dart';

part 'local_transaction_model.g.dart';

@JsonSerializable()
class LocalTransactionModel {
  @JsonKey(name: 'id_transaksi_lokal')
  final String idTransaksiLokal;

  @JsonKey(name: 'kategori_kendaraan')
  final String kategoriKendaraan;

  final int nominal;

  @JsonKey(name: 'metode_pembayaran')
  final String metodePembayaran;

  @JsonKey(name: 'no_kartu_kue') // 🚀 KEMBALIKAN INI
  final String? noKartuKue;

  @JsonKey(name: 'plat_nomor')
  final String platNomor;

  @JsonKey(name: 'waktu_transaksi')
  final String waktuTransaksi;

  final String status;

  @JsonKey(name: 'id_jukir')
  final String idJukir;

  @JsonKey(name: 'nama_jukir')
  final String namaJukir;

  @JsonKey(name: 'foto_kendaraan')
  final String? fotoKendaraan;

  @JsonKey(name: 'mode_plat')
  final int modePlat;

  @JsonKey(name: 'is_sync')
  final int isSync;

  final String? latitude;
  final String? longitude;

  const LocalTransactionModel({
    required this.idTransaksiLokal,
    required this.kategoriKendaraan,
    required this.nominal,
    required this.metodePembayaran,
    this.noKartuKue,
    required this.platNomor,
    required this.waktuTransaksi,
    required this.status,
    required this.idJukir,
    required this.namaJukir,
    this.fotoKendaraan,
    required this.modePlat,
    required this.isSync,
    this.latitude,
    this.longitude,
  });

  factory LocalTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$LocalTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalTransactionModelToJson(this);
}

extension LocalTransactionMapper on LocalTransactionModel {
  HistoryItemModel toHistoryItem(Map<String, dynamic> profile) {
    return HistoryItemModel(
      id: 0,
      orderId: idTransaksiLokal,
      jenisTarif: kategoriKendaraan,
      sof: nominal == 0 ? 'FREE' : 'CASH',
      platNumber: platNomor,
      tglTrx: waktuTransaksi,
      kredit: nominal,
      namaPetugas: profile['namaUser'] ?? 'Petugas',
      modePlat: modePlat,
      shift: profile['shift']?.toString() ?? '1',
    );
  }
}
