// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_jukir_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataJukirModel _$DataJukirModelFromJson(Map<String, dynamic> json) =>
    DataJukirModel(
      nop: json['nop'] as String? ?? '',
      username: json['username'] as String? ?? '',
      idDevice: json['idDevice'] as String? ?? '',
      nopFormatted: json['nopFormatted'] as String? ?? '',
      namaPetugas: json['namaPetugas'] as String? ?? '',
      shift: json['shift'] as String? ?? '',
    );

Map<String, dynamic> _$DataJukirModelToJson(DataJukirModel instance) =>
    <String, dynamic>{
      'nop': instance.nop,
      'username': instance.username,
      'idDevice': instance.idDevice,
      'nopFormatted': instance.nopFormatted,
      'namaPetugas': instance.namaPetugas,
      'shift': instance.shift,
    };
