// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseModelImpl _$$AuthResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthResponseModelImpl(
  accessToken: json['accessToken'] as String? ?? '',
  nop: json['nop'] as String? ?? '',
  uuidStatic: json['uuidStatic'] as String? ?? '',
  roleLoginId: (json['roleLoginId'] as num?)?.toInt() ?? 0,
  pungutTarif: (json['pungutTarif'] as num?)?.toInt() ?? 0,
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
  'nop': instance.nop,
  'uuidStatic': instance.uuidStatic,
  'roleLoginId': instance.roleLoginId,
  'pungutTarif': instance.pungutTarif,
  'nopList': instance.nopList,
};

_$NopModelImpl _$$NopModelImplFromJson(Map<String, dynamic> json) =>
    _$NopModelImpl(
      nop: json['nop'] as String? ?? '',
      namaOp: json['namaOp'] as String? ?? '',
      alamatOp: json['alamatOp'] as String? ?? '',
      isDigital: json['isDigital'] as bool? ?? false,
      pungutTarif: (json['pungutTarif'] as num?)?.toInt() ?? 0,
      uptb: (json['uptb'] as num?)?.toInt() ?? 0,
      kdCamat: json['kdCamat'] as String? ?? '',
      nmCamat: json['nmCamat'] as String? ?? '',
      kdLurah: json['kdLurah'] as String? ?? '',
      nmLurah: json['nmLurah'] as String? ?? '',
    );

Map<String, dynamic> _$$NopModelImplToJson(_$NopModelImpl instance) =>
    <String, dynamic>{
      'nop': instance.nop,
      'namaOp': instance.namaOp,
      'alamatOp': instance.alamatOp,
      'isDigital': instance.isDigital,
      'pungutTarif': instance.pungutTarif,
      'uptb': instance.uptb,
      'kdCamat': instance.kdCamat,
      'nmCamat': instance.nmCamat,
      'kdLurah': instance.kdLurah,
      'nmLurah': instance.nmLurah,
    };
