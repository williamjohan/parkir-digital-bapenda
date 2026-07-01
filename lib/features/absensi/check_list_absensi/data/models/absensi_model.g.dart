// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absensi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbsensiModel _$AbsensiModelFromJson(Map<String, dynamic> json) => AbsensiModel(
  date: _toDateTime(json['date']),
  isPresent: json['isPresent'] == null ? false : _toBool(json['isPresent']),
  latitude: json['latitude'] == null ? 0.0 : _toDouble(json['latitude']),
  longitude: json['longitude'] == null ? 0.0 : _toDouble(json['longitude']),
  checkList: json['checkList'] == null
      ? null
      : AbsensiCheckListModel.fromJson(
          json['checkList'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AbsensiModelToJson(AbsensiModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'isPresent': instance.isPresent,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'checkList': instance.checkList?.toJson(),
    };

AbsensiCheckListModel _$AbsensiCheckListModelFromJson(
  Map<String, dynamic> json,
) => AbsensiCheckListModel(
  edc: json['edc'] == null ? false : _toBool(json['edc']),
  qrisRompi: json['qrisRompi'] == null ? false : _toBool(json['qrisRompi']),
  cctv: json['cctv'] == null ? false : _toBool(json['cctv']),
  tsPark: json['tsPark'] == null ? false : _toBool(json['tsPark']),
  totalMotor: json['totalMotor'] == null ? 0 : _toInt(json['totalMotor']),
  totalMobil: json['totalMobil'] == null ? 0 : _toInt(json['totalMobil']),
);

Map<String, dynamic> _$AbsensiCheckListModelToJson(
  AbsensiCheckListModel instance,
) => <String, dynamic>{
  'edc': instance.edc,
  'qrisRompi': instance.qrisRompi,
  'cctv': instance.cctv,
  'tsPark': instance.tsPark,
  'totalMotor': instance.totalMotor,
  'totalMobil': instance.totalMobil,
};
