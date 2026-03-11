// lib/features/auth/data/models/auth_response_model.dart

import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

// explicitToJson: true sangat penting jika model ini punya nested object (UserModel)
@JsonSerializable(explicitToJson: true)
class AuthResponseModel {
  @JsonKey(name: 'access_token', defaultValue: '')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  @JsonKey(name: 'user')
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
