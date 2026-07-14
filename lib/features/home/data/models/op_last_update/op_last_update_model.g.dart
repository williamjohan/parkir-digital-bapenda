// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'op_last_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpLastUpdateModelImpl _$$OpLastUpdateModelImplFromJson(
  Map<String, dynamic> json,
) => _$OpLastUpdateModelImpl(
  isSuccess: json['isSuccess'] as bool? ?? false,
  statusCode: (json['statusCode'] as num?)?.toInt() ?? 0,
  message: json['message'] as String? ?? '',
  data: json['data'] as String? ?? '',
);

Map<String, dynamic> _$$OpLastUpdateModelImplToJson(
  _$OpLastUpdateModelImpl instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};
