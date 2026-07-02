// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jadwal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JadwalModel _$JadwalModelFromJson(Map<String, dynamic> json) => JadwalModel(
  hari: (json['hari'] as num).toInt(),
  hariNama: json['hariNama'] as String,
  bulan: (json['bulan'] as num).toInt(),
  bulanNama: json['bulanNama'] as String,
  tahun: (json['tahun'] as num).toInt(),
  tahunNama: json['tahunNama'] as String,
  jamMasuk: json['jamMasuk'] as String?,
  jamPulang: json['jamPulang'] as String?,
  jamCheckIn: json['jamCheckIn'] as String?,
  jamCheckOut: json['jamCheckOut'] as String?,
  isLibur: json['isLibur'] as bool,
);

Map<String, dynamic> _$JadwalModelToJson(JadwalModel instance) =>
    <String, dynamic>{
      'hari': instance.hari,
      'hariNama': instance.hariNama,
      'bulan': instance.bulan,
      'bulanNama': instance.bulanNama,
      'tahun': instance.tahun,
      'tahunNama': instance.tahunNama,
      'jamMasuk': instance.jamMasuk,
      'jamPulang': instance.jamPulang,
      'jamCheckIn': instance.jamCheckIn,
      'jamCheckOut': instance.jamCheckOut,
      'isLibur': instance.isLibur,
    };
