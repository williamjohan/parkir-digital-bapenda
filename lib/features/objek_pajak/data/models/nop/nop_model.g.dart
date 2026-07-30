// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NopModelImpl _$$NopModelImplFromJson(Map<String, dynamic> json) =>
    _$NopModelImpl(
      isSuccess: json['isSuccess'] as bool? ?? false,
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? const NopDataModel()
          : NopDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NopModelImplToJson(_$NopModelImpl instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

_$NopDataModelImpl _$$NopDataModelImplFromJson(Map<String, dynamic> json) =>
    _$NopDataModelImpl(
      nop: json['nop'] as String? ?? '',
      namaOp: json['namaOp'] as String? ?? '',
      alamatOp: json['alamatOp'] as String? ?? '',
      isDigital: json['isDigital'] as bool? ?? false,
      pungutTarif: (json['pungutTarif'] as num?)?.toInt() ?? 0,
      uptb: (json['uptb'] as num?)?.toInt() ?? 0,
      statusDigitalisasi: json['statusDigitalisasi'] as String? ?? '',
      totalPendapatan: (json['totalPendapatan'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$NopDataModelImplToJson(_$NopDataModelImpl instance) =>
    <String, dynamic>{
      'nop': instance.nop,
      'namaOp': instance.namaOp,
      'alamatOp': instance.alamatOp,
      'isDigital': instance.isDigital,
      'pungutTarif': instance.pungutTarif,
      'uptb': instance.uptb,
      'statusDigitalisasi': instance.statusDigitalisasi,
      'totalPendapatan': instance.totalPendapatan,
    };
