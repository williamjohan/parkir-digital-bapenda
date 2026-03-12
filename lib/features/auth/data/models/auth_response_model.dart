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

  // KITA KEMBALIKAN OBJEK USER KE SINI!
  // Ini yang menghubungkan data Login dengan entitas Jukir Anda.
  @JsonKey(name: 'user')
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
