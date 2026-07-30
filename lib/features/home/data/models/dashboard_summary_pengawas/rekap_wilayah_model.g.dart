// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rekap_wilayah_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RekapWilayahResponseModel _$RekapWilayahResponseModelFromJson(
  Map<String, dynamic> json,
) => RekapWilayahResponseModel(
  isSuccess: json['isSuccess'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : RekapWilayahDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RekapWilayahResponseModelToJson(
  RekapWilayahResponseModel instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

RekapWilayahDataModel _$RekapWilayahDataModelFromJson(
  Map<String, dynamic> json,
) => RekapWilayahDataModel(
  kodeOpd: json['kodeOpd'] as String?,
  namaOpd: json['namaOpd'] as String?,
  detailList: (json['detailList'] as List<dynamic>?)
      ?.map((e) => DetailRekapWilayahModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RekapWilayahDataModelToJson(
  RekapWilayahDataModel instance,
) => <String, dynamic>{
  'kodeOpd': instance.kodeOpd,
  'namaOpd': instance.namaOpd,
  'detailList': instance.detailList,
};

DetailRekapWilayahModel _$DetailRekapWilayahModelFromJson(
  Map<String, dynamic> json,
) => DetailRekapWilayahModel(
  kdCamat: json['kdCamat'] as String?,
  nmCamat: json['nmCamat'] as String?,
  jmlObjekPajak: (json['jmlObjekPajak'] as num?)?.toInt(),
  jmlTju: (json['jmlTju'] as num?)?.toInt(),
);

Map<String, dynamic> _$DetailRekapWilayahModelToJson(
  DetailRekapWilayahModel instance,
) => <String, dynamic>{
  'kdCamat': instance.kdCamat,
  'nmCamat': instance.nmCamat,
  'jmlObjekPajak': instance.jmlObjekPajak,
  'jmlTju': instance.jmlTju,
};
