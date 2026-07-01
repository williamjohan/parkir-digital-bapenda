// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInModel _$CheckInModelFromJson(Map<String, dynamic> json) => CheckInModel(
  checkInJmlMobil: (json['CheckInJmlMobil'] as num).toDouble(),
  checkInJmlMotor: (json['CheckInJmlMotor'] as num).toDouble(),
  latitude: json['Latitude'] as String,
  longitude: json['Longitude'] as String,
  detailAlatList: (json['DetailAlatList'] as List<dynamic>)
      .map((e) => AlatItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CheckInModelToJson(CheckInModel instance) =>
    <String, dynamic>{
      'CheckInJmlMobil': instance.checkInJmlMobil,
      'CheckInJmlMotor': instance.checkInJmlMotor,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'DetailAlatList': instance.detailAlatList,
    };
