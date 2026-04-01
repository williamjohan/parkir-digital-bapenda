// lib/features/auth/data/models/user_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'idUser', defaultValue: '')
  final String idUser;

  // BE mengirim 'namaUser', kita petakan ke 'nama'
  @JsonKey(name: 'namaUser', defaultValue: '')
  final String namaUser;

  @JsonKey(name: 'nop', defaultValue: '')
  final String nop;

  @JsonKey(name: 'namaObjekPajak', defaultValue: '')
  final String namaObjekPajak;

  @JsonKey(name: 'alamat', defaultValue: '')
  final String alamat;

  @JsonKey(name: 'pungutTarif', defaultValue: 0)
  final int pungutTarif;

  @JsonKey(name: 'lokasiId', defaultValue: 0)
  final int lokasiId;

  @JsonKey(name: 'namaLokasi', defaultValue: '')
  final String namaLokasi;

  @JsonKey(name: 'kodeGate', defaultValue: '')
  final String kodeGate;

  @JsonKey(name: 'namaGate', defaultValue: '')
  final String namaGate;

  UserModel({
    required this.idUser,
    required this.namaUser,
    required this.nop,
    this.namaObjekPajak = '',
    this.alamat = '',
    this.pungutTarif = 0,
    this.lokasiId = 0,
    this.namaLokasi = '',
    this.kodeGate = '',
    this.namaGate = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
