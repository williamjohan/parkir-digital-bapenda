// lib/features/auth/data/models/user_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  // [KUNCI KESAKTIAN]: BE mengirim 'idUser', tapi di aplikasi kita tetap pakai 'idJukir'
  @JsonKey(name: 'idUser', defaultValue: '')
  final String idUser;

  // BE mengirim 'namaUser', kita petakan ke 'nama'
  @JsonKey(name: 'namaUser', defaultValue: '')
  final String namaUser;

  @JsonKey(name: 'nop', defaultValue: '')
  final String nop;

  // [TAMBAHAN BONUS BE]: Sangat berguna untuk ditampilkan di Header Home Screen Jukir
  @JsonKey(name: 'namaObjekPajak', defaultValue: '')
  final String namaObjekPajak;

  @JsonKey(name: 'alamat', defaultValue: '')
  final String alamat;

  // [TAMBAHAN WAJIB]: Menangkap status tarif dari Backend (0/1/2)
  @JsonKey(name: 'pungutTarif', defaultValue: 0)
  final int pungutTarif;

  UserModel({
    required this.idUser,
    required this.namaUser,
    required this.nop,
    this.namaObjekPajak = '',
    this.alamat = '',
    this.pungutTarif = 0, // Default 0 (Tidak diketahui) agar aman dari null
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
