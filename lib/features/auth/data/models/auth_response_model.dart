// lib/features/auth/data/models/auth_response_model.dart

import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthResponseModel {
  // Untuk infrastruktur token, kita ikuti persis nama dari BE
  @JsonKey(name: 'accessToken', defaultValue: '')
  final String accessToken;

  @JsonKey(name: 'refreshToken', defaultValue: '')
  final String refreshToken;

  @JsonKey(name: 'nop', defaultValue: '')
  final String nop;

  @JsonKey(name: 'uuidStatic', defaultValue: '')
  final String uuidStatic;

  @JsonKey(name: 'isJukir', defaultValue: false)
  final bool isJukir;

  @JsonKey(name: 'nopList', defaultValue: [])
  final List<NopModel> nopList;

  // KITA KEMBALIKAN OBJEK USER KE SINI!
  // Ini yang menghubungkan data Login dengan entitas Jukir Anda.
  @JsonKey(name: 'user')
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.nop,
    // required this.user,
    required this.uuidStatic,
    required this.isJukir,
    required this.nopList,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}

@JsonSerializable()
class NopModel {
  @JsonKey(name: 'nop', defaultValue: '')
  final String nop;

  @JsonKey(name: 'namaOp', defaultValue: '')
  final String namaOp;

  @JsonKey(name: 'alamatOp', defaultValue: '')
  final String alamatOp;

  const NopModel({
    required this.nop,
    required this.namaOp,
    required this.alamatOp,
  });

  factory NopModel.fromJson(Map<String, dynamic> json) =>
      _$NopModelFromJson(json);

  Map<String, dynamic> toJson() => _$NopModelToJson(this);
}
