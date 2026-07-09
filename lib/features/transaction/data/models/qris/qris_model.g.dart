// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qris_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QrisResponseModelImpl _$$QrisResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$QrisResponseModelImpl(
  jenisKendaraanId: (json['jenisKendaraanId'] as num?)?.toInt() ?? 0,
  qrisImageBase64: json['qrisImageBase64'] as String? ?? '',
  kodeQris: json['kodeQris'] as String? ?? '',
);

Map<String, dynamic> _$$QrisResponseModelImplToJson(
  _$QrisResponseModelImpl instance,
) => <String, dynamic>{
  'jenisKendaraanId': instance.jenisKendaraanId,
  'qrisImageBase64': instance.qrisImageBase64,
  'kodeQris': instance.kodeQris,
};

_$QrisLocalModelImpl _$$QrisLocalModelImplFromJson(Map<String, dynamic> json) =>
    _$QrisLocalModelImpl(
      path: json['path'] as String? ?? '',
      kodeQris: json['kodeQris'] as String? ?? '',
    );

Map<String, dynamic> _$$QrisLocalModelImplToJson(
  _$QrisLocalModelImpl instance,
) => <String, dynamic>{'path': instance.path, 'kodeQris': instance.kodeQris};
