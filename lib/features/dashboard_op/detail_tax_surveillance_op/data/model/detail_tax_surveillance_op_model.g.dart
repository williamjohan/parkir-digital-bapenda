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
        json['start_date'] as String,
      ),
      endDate: const ServerUtcDateTimeConverter().fromJson(
        json['end_date'] as String,
      ),
    );

Map<String, dynamic> _$$TaxSurveillanceDetailRequestModelImplToJson(
  _$TaxSurveillanceDetailRequestModelImpl instance,
) => <String, dynamic>{
  'nop': instance.nop,
  'start_date': const ServerUtcDateTimeConverter().toJson(instance.startDate),
  'end_date': const ServerUtcDateTimeConverter().toJson(instance.endDate),
};

_$TaxSurveillanceDetailResponseModelImpl
_$$TaxSurveillanceDetailResponseModelImplFromJson(Map<String, dynamic> json) =>
    _$TaxSurveillanceDetailResponseModelImpl(
      jenisKendaraan: json['jenis_kendaraan'] as String? ?? 'Tidak Diketahui',
      nominal: (json['nominal'] as num?)?.toInt() ?? 0,
      tgl: DateTime.parse(json['tgl'] as String),
    );

Map<String, dynamic> _$$TaxSurveillanceDetailResponseModelImplToJson(
  _$TaxSurveillanceDetailResponseModelImpl instance,
) => <String, dynamic>{
  'jenis_kendaraan': instance.jenisKendaraan,
  'nominal': instance.nominal,
  'tgl': instance.tgl.toIso8601String(),
};
