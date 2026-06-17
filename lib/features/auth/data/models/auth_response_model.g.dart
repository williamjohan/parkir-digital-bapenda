// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      nop: json['nop'] as String? ?? '',
      uuidStatic: json['uuidStatic'] as String? ?? '',
      isJukir: json['isJukir'] as bool? ?? false,
      nopList:
          (json['nopList'] as List<dynamic>?)
              ?.map((e) => NopModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'nop': instance.nop,
      'uuidStatic': instance.uuidStatic,
      'isJukir': instance.isJukir,
      'nopList': instance.nopList.map((e) => e.toJson()).toList(),
      'user': instance.user.toJson(),
    };

NopModel _$NopModelFromJson(Map<String, dynamic> json) => NopModel(
  nop: json['nop'] as String? ?? '',
  namaOp: json['namaOp'] as String? ?? '',
  alamatOp: json['alamatOp'] as String? ?? '',
);

Map<String, dynamic> _$NopModelToJson(NopModel instance) => <String, dynamic>{
  'nop': instance.nop,
  'namaOp': instance.namaOp,
  'alamatOp': instance.alamatOp,
};
