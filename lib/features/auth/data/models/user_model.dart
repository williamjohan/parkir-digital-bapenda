// lib/features/auth/data/models/user_model.dart

import 'package:json_annotation/json_annotation.dart';

import 'tarif_parkir_model.dart';

part 'user_model.g.dart';

// --- [TAMENG ANTI-PELURU BE] ---
// Fungsi ini akan memaksa apapun (int, double, null) menjadi String yang aman.
String _toString(dynamic value) => value?.toString() ?? '';

// Fungsi ini akan memaksa apapun (String, null) menjadi Integer yang aman.
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
// ------------------------------

// parsing list tarif parkir
List<TarifParkirModel> _toTarifList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value
        .map((e) => TarifParkirModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return [];
}
// ------------------------------

@JsonSerializable()
class UserModel {
  // Gunakan fromJson untuk mengalihkan proses parsing ke fungsi tameng kita
  @JsonKey(name: 'idUser', fromJson: _toString)
  final String idUser;

  @JsonKey(name: 'namaUser', fromJson: _toString)
  final String namaUser;

  @JsonKey(name: 'nop', fromJson: _toString)
  final String nop;

  @JsonKey(name: 'namaObjekPajak', fromJson: _toString)
  final String namaObjekPajak;

  @JsonKey(name: 'alamat', fromJson: _toString)
  final String alamat;

  @JsonKey(name: 'pungutTarif', fromJson: _toInt)
  final int pungutTarif;

  @JsonKey(name: 'lokasiId', fromJson: _toInt)
  final int lokasiId;

  @JsonKey(name: 'namaLokasi', fromJson: _toString)
  final String namaLokasi;

  @JsonKey(name: 'kodeGate', fromJson: _toString)
  final String kodeGate;

  @JsonKey(name: 'namaGate', fromJson: _toString)
  final String namaGate;

  @JsonKey(name: 'idDevice', fromJson: _toString)
  final String idDevice;

  @JsonKey(name: 'shift', fromJson: _toString)
  final String shift;

  // 🔥 FIELD BARU
  @JsonKey(name: 'tarifParkirs', fromJson: _toTarifList)
  final List<TarifParkirModel> tarifParkirs;

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
    this.idDevice = '',
    this.shift = '',
    this.tarifParkirs = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
