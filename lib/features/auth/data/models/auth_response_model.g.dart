// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseModelImpl _$$AuthResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthResponseModelImpl(
  accessToken: json['accessToken'] as String? ?? '',
  refreshToken: json['refreshToken'] as String? ?? '',
  nop: json['nop'] as String? ?? '',
  uuidStatic: json['uuidStatic'] as String? ?? '',
  roleLoginId: (json['roleLoginId'] as num?)?.toInt() ?? 0,
  nopList:
      (json['nopList'] as List<dynamic>?)
          ?.map((e) => NopModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AuthResponseModelImplToJson(
  _$AuthResponseModelImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'nop': instance.nop,
  'uuidStatic': instance.uuidStatic,
  'roleLoginId': instance.roleLoginId,
  'nopList': instance.nopList,
};

_$NopModelImpl _$$NopModelImplFromJson(Map<String, dynamic> json) =>
    _$NopModelImpl(
      nop: json['nop'] as String? ?? '',
      namaOp: json['namaOp'] as String? ?? '',
      alamatOp: json['alamatOp'] as String? ?? '',
      isDigital: json['isDigital'] as bool? ?? false,
    );

Map<String, dynamic> _$$NopModelImplToJson(_$NopModelImpl instance) =>
    <String, dynamic>{
      'nop': instance.nop,
      'namaOp': instance.namaOp,
      'alamatOp': instance.alamatOp,
      'isDigital': instance.isDigital,
    };
