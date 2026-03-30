import 'package:json_annotation/json_annotation.dart';

part 'local_transaction_model.g.dart';

@JsonSerializable()
class LocalTransactionModel {
  @JsonKey(name: 'id_transaksi_lokal')
  final String idTransaksiLokal; // UUID

  @JsonKey(name: 'nominal')
  final int nominal;

  // [PERBAIKAN]: Menjadi Nullable (?) untuk mengakomodasi "Tanpa Plat"
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

  // [PERBAIKAN]: Menjadi Nullable (?) untuk mengakomodasi "Tanpa Plat"
  @JsonKey(name: 'foto_kendaraan')
  final String? fotoKendaraan; // Base64 String (Maksimal ~10kb)

  // [TAMBAHAN BARU]: 0 = Tanpa Plat, 1 = Pakai Plat
  @JsonKey(name: 'mode_plat')
  final int modePlat;

  // [TAMBAHAN BARU]: 0 = Belum Sync, 1 = Sudah Sync
  @JsonKey(name: 'is_sync')
  final int isSync;

  LocalTransactionModel({
    required this.idTransaksiLokal,
    required this.nominal,
    this.platNomor, // Tidak lagi required secara mutlak
    required this.kategoriKendaraan,
    required this.waktuTransaksi,
    required this.status,
    required this.idJukir,
    required this.namaJukir,
    required this.nop,
    this.fotoKendaraan, // Tidak lagi required secara mutlak
    required this.modePlat,
    required this.isSync,
  });

  factory LocalTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$LocalTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalTransactionModelToJson(this);
}
