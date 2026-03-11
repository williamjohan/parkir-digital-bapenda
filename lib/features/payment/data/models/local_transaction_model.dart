// lib/features/payment/data/models/local_transaction_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'local_transaction_model.g.dart';

@JsonSerializable()
class LocalTransactionModel {
  @JsonKey(name: 'id_transaksi_lokal')
  final String idTransaksiLokal; // UUID

  @JsonKey(name: 'nominal')
  final int nominal;

  @JsonKey(name: 'plat_nomor')
  final String platNomor;

  @JsonKey(name: 'kategori_kendaraan')
  final String kategoriKendaraan;

  @JsonKey(name: 'waktu_transaksi')
  final String waktuTransaksi; // Format ISO-8601 (String)

  @JsonKey(name: 'status')
  final String status; // 'PENDING' atau 'PAID'

  @JsonKey(name: 'id_jukir')
  final String idJukir;

  @JsonKey(name: 'nama_jukir')
  final String namaJukir;

  @JsonKey(name: 'nop')
  final String nop;

  @JsonKey(name: 'foto_kendaraan')
  final String fotoKendaraan; // Base64 String (Maksimal ~10kb)

  LocalTransactionModel({
    required this.idTransaksiLokal,
    required this.nominal,
    required this.platNomor,
    required this.kategoriKendaraan,
    required this.waktuTransaksi,
    required this.status,
    required this.idJukir,
    required this.namaJukir,
    required this.nop,
    required this.fotoKendaraan,
  });

  factory LocalTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$LocalTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalTransactionModelToJson(this);
}
