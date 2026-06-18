// lib/features/auth/data/models/auth_response_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    @Default('') String accessToken,
    @Default('') String refreshToken,
    @Default('') String nop,
    @Default('') String uuidStatic,
    @Default(0) int roleLoginId,
    @Default([]) List<NopModel> nopList,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}

@freezed
class NopModel with _$NopModel {
  const factory NopModel({
    @Default('') String nop,
    @Default('') String namaOp,
    @Default('') String alamatOp,
  }) = _NopModel;

  factory NopModel.fromJson(Map<String, dynamic> json) =>
      _$NopModelFromJson(json);
}
