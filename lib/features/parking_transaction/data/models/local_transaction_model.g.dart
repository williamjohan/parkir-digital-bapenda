// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalTransactionModel _$LocalTransactionModelFromJson(
  Map<String, dynamic> json,
) => LocalTransactionModel(
  idTransaksiLokal: json['id_transaksi_lokal'] as String,
  kategoriKendaraan: json['kategori_kendaraan'] as String,
  nominal: (json['nominal'] as num).toInt(),
  metodePembayaran: json['metode_pembayaran'] as String,
  noKartuKue: json['no_kartu_kue'] as String?,
  platNomor: json['plat_nomor'] as String,
  waktuTransaksi: json['waktu_transaksi'] as String,
  status: json['status'] as String,
  idJukir: json['id_jukir'] as String,
  namaJukir: json['nama_jukir'] as String,
  fotoKendaraan: json['foto_kendaraan'] as String?,
  modePlat: (json['mode_plat'] as num).toInt(),
  isSync: (json['is_sync'] as num).toInt(),
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
);

Map<String, dynamic> _$LocalTransactionModelToJson(
  LocalTransactionModel instance,
) => <String, dynamic>{
  'id_transaksi_lokal': instance.idTransaksiLokal,
  'kategori_kendaraan': instance.kategoriKendaraan,
  'nominal': instance.nominal,
  'metode_pembayaran': instance.metodePembayaran,
  'no_kartu_kue': instance.noKartuKue,
  'plat_nomor': instance.platNomor,
  'waktu_transaksi': instance.waktuTransaksi,
  'status': instance.status,
  'id_jukir': instance.idJukir,
  'nama_jukir': instance.namaJukir,
  'foto_kendaraan': instance.fotoKendaraan,
  'mode_plat': instance.modePlat,
  'is_sync': instance.isSync,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
