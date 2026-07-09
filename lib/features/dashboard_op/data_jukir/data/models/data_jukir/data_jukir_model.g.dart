// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_jukir_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataJukirModel _$DataJukirModelFromJson(Map<String, dynamic> json) =>
    DataJukirModel(
      idDevice: json['idDevice'] as String? ?? '',
      petugas: json['petugas'] as String? ?? '',
      shift: json['shift'] as String? ?? '',
      totalMobilHariIni: (json['totalMobilHariIni'] as num?)?.toInt() ?? 0,
      totalMotorHariIni: (json['totalMotorHariIni'] as num?)?.toInt() ?? 0,
      totalNominalMobilHariIni:
          (json['totalNominalMobilHariIni'] as num?)?.toInt() ?? 0,
      totalNominalMotorHariIni:
          (json['totalNominalMotorHariIni'] as num?)?.toInt() ?? 0,
      totalKendaraan: (json['totalKendaraan'] as num?)?.toInt() ?? 0,
      totalNominal: (json['totalNominal'] as num?)?.toInt() ?? 0,
      usernameList:
          (json['usernameList'] as List<dynamic>?)
              ?.map((e) => UsernameModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$DataJukirModelToJson(DataJukirModel instance) =>
    <String, dynamic>{
      'idDevice': instance.idDevice,
      'petugas': instance.petugas,
      'shift': instance.shift,
      'totalMobilHariIni': instance.totalMobilHariIni,
      'totalMotorHariIni': instance.totalMotorHariIni,
      'totalNominalMobilHariIni': instance.totalNominalMobilHariIni,
      'totalNominalMotorHariIni': instance.totalNominalMotorHariIni,
      'totalKendaraan': instance.totalKendaraan,
      'totalNominal': instance.totalNominal,
      'usernameList': instance.usernameList.map((e) => e.toJson()).toList(),
    };

UsernameModel _$UsernameModelFromJson(Map<String, dynamic> json) =>
    UsernameModel(
      username: json['username'] as String? ?? '',
      namaPetugas: json['namaPetugas'] as String? ?? '',
      fotoBase64: json['fotoBase64'] as String? ?? '',
    );

Map<String, dynamic> _$UsernameModelToJson(UsernameModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'namaPetugas': instance.namaPetugas,
      'fotoBase64': instance.fotoBase64,
    };
