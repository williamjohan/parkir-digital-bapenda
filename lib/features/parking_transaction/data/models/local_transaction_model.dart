// lib/features/parking_transaction/data/models/local_transaction_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'local_transaction_model.g.dart';

@JsonSerializable()
class LocalTransactionModel {
  @JsonKey(name: 'id_transaksi_lokal')
  final String idTransaksiLokal;

  @JsonKey(name: 'nominal')
  final int nominal;

  @JsonKey(name: 'plat_nomor')
  final String? platNomor;

  @JsonKey(name: 'kategori_kendaraan')
  final String kategoriKendaraan;

  @JsonKey(name: 'waktu_transaksi')
  final String waktuTransaksi; // Format ISO-8601 (String)

  @JsonKey(name: 'status')
  final String status; // 'PENDING_PAYMENT', 'PAID_OFFLINE', 'FREE_OFFLINE'

  @JsonKey(name: 'id_jukir')
  final String idJukir;

  @JsonKey(name: 'nama_jukir')
  final String namaJukir;

  @JsonKey(name: 'nop')
  final String nop;

  @JsonKey(name: 'foto_kendaraan')
  final String? fotoKendaraan; // Base64 String (Maksimal ~10kb)

  @JsonKey(name: 'mode_plat')
  final int modePlat;

  @JsonKey(name: 'is_sync')
  final int isSync;

  @JsonKey(name: 'latitude')
  final String? latitude;

  @JsonKey(name: 'longitude')
  final String? longitude;

  @JsonKey(name: 'no_kartu_kue')
  final String? noKartuKue;

  LocalTransactionModel({
    required this.idTransaksiLokal,
    required this.nominal,
    this.platNomor,
    required this.kategoriKendaraan,
    required this.waktuTransaksi,
    required this.status,
    required this.idJukir,
    required this.namaJukir,
    required this.nop,
    this.fotoKendaraan,
    required this.modePlat,
    required this.isSync,
    this.latitude,
    this.longitude,
    this.noKartuKue,
  });

  factory LocalTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$LocalTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalTransactionModelToJson(this);
}
