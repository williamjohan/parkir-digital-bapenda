// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckOutModel _$CheckOutModelFromJson(Map<String, dynamic> json) =>
    CheckOutModel(
      checkOutJmlMobil: (json['CheckOutJmlMobil'] as num).toDouble(),
      checkOutJmlMotor: (json['CheckOutJmlMotor'] as num).toDouble(),
      latitude: json['Latitude'] as String,
      longitude: json['Longitude'] as String,
      detailAlatList: (json['DetailAlatList'] as List<dynamic>)
          .map((e) => AlatItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CheckOutModelToJson(CheckOutModel instance) =>
    <String, dynamic>{
      'CheckOutJmlMobil': instance.checkOutJmlMobil,
      'CheckOutJmlMotor': instance.checkOutJmlMotor,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'DetailAlatList': instance.detailAlatList,
    };
