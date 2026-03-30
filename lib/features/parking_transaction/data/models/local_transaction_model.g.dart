// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalTransactionModel _$LocalTransactionModelFromJson(
  Map<String, dynamic> json,
) => LocalTransactionModel(
  idTransaksiLokal: json['id_transaksi_lokal'] as String,
  nominal: (json['nominal'] as num).toInt(),
  platNomor: json['plat_nomor'] as String?,
  kategoriKendaraan: json['kategori_kendaraan'] as String,
  waktuTransaksi: json['waktu_transaksi'] as String,
  status: json['status'] as String,
  idJukir: json['id_jukir'] as String,
  namaJukir: json['nama_jukir'] as String,
  nop: json['nop'] as String,
  fotoKendaraan: json['foto_kendaraan'] as String?,
  modePlat: (json['mode_plat'] as num).toInt(),
  isSync: (json['is_sync'] as num).toInt(),
);

Map<String, dynamic> _$LocalTransactionModelToJson(
  LocalTransactionModel instance,
) => <String, dynamic>{
  'id_transaksi_lokal': instance.idTransaksiLokal,
  'nominal': instance.nominal,
  'plat_nomor': instance.platNomor,
  'kategori_kendaraan': instance.kategoriKendaraan,
  'waktu_transaksi': instance.waktuTransaksi,
  'status': instance.status,
  'id_jukir': instance.idJukir,
  'nama_jukir': instance.namaJukir,
  'nop': instance.nop,
  'foto_kendaraan': instance.fotoKendaraan,
  'mode_plat': instance.modePlat,
  'is_sync': instance.isSync,
};
