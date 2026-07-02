// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absensi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AbsensiRequestModelImpl _$$AbsensiRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$AbsensiRequestModelImpl(
  latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
  longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
  totalMotor: (json['totalMotor'] as num?)?.toInt() ?? 0,
  totalMobil: (json['totalMobil'] as num?)?.toInt() ?? 0,
  detailAlatIds:
      (json['detailAlatIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  fotoPath: json['fotoPath'] as String? ?? '',
  isCheckIn: json['isCheckIn'] as bool? ?? true,
);

Map<String, dynamic> _$$AbsensiRequestModelImplToJson(
  _$AbsensiRequestModelImpl instance,
) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'totalMotor': instance.totalMotor,
  'totalMobil': instance.totalMobil,
  'detailAlatIds': instance.detailAlatIds,
  'fotoPath': instance.fotoPath,
  'isCheckIn': instance.isCheckIn,
};
