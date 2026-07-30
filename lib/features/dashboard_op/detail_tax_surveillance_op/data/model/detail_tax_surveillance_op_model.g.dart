// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_tax_surveillance_op_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaxSurveillanceDetailRequestModelImpl
_$$TaxSurveillanceDetailRequestModelImplFromJson(Map<String, dynamic> json) =>
    _$TaxSurveillanceDetailRequestModelImpl(
      nop: json['nop'] as String,
      startDate: const ServerUtcDateTimeConverter().fromJson(
        json['startDate'] as String,
      ),
      endDate: const ServerUtcDateTimeConverter().fromJson(
        json['endDate'] as String,
      ),
    );

Map<String, dynamic> _$$TaxSurveillanceDetailRequestModelImplToJson(
  _$TaxSurveillanceDetailRequestModelImpl instance,
) => <String, dynamic>{
  'nop': instance.nop,
  'startDate': const ServerUtcDateTimeConverter().toJson(instance.startDate),
  'endDate': const ServerUtcDateTimeConverter().toJson(instance.endDate),
};

_$TaxSurveillanceDetailResponseModelImpl
_$$TaxSurveillanceDetailResponseModelImplFromJson(Map<String, dynamic> json) =>
    _$TaxSurveillanceDetailResponseModelImpl(
      jenisKendaraan: json['jenisKendaraan'] as String,
      nominal: (json['nominal'] as num).toInt(),
      tgl: DateTime.parse(json['tgl'] as String),
    );

Map<String, dynamic> _$$TaxSurveillanceDetailResponseModelImplToJson(
  _$TaxSurveillanceDetailResponseModelImpl instance,
) => <String, dynamic>{
  'jenisKendaraan': instance.jenisKendaraan,
  'nominal': instance.nominal,
  'tgl': instance.tgl.toIso8601String(),
};
