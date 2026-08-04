// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riwayat_absensi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RiwayatAbsensiModel _$RiwayatAbsensiModelFromJson(Map<String, dynamic> json) =>
    RiwayatAbsensiModel(
      tanggal: json['tanggal'] as String,
      tanggalString: json['tanggalString'] as String,
      objekList: (json['objekList'] as List<dynamic>)
          .map((e) => ObjekPengawasanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RiwayatAbsensiModelToJson(
  RiwayatAbsensiModel instance,
) => <String, dynamic>{
  'tanggal': instance.tanggal,
  'tanggalString': instance.tanggalString,
  'objekList': instance.objekList,
};

ObjekPengawasanModel _$ObjekPengawasanModelFromJson(
  Map<String, dynamic> json,
) => ObjekPengawasanModel(
  idTempat: json['idTempat'] as String,
  namaTempat: json['namaTempat'] as String,
  checkIn: json['checkIn'] == null
      ? null
      : CheckInOutModel.fromJson(json['checkIn'] as Map<String, dynamic>),
  checkOut: json['checkOut'] == null
      ? null
      : CheckInOutModel.fromJson(json['checkOut'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ObjekPengawasanModelToJson(
  ObjekPengawasanModel instance,
) => <String, dynamic>{
  'idTempat': instance.idTempat,
  'namaTempat': instance.namaTempat,
  'checkIn': instance.checkIn,
  'checkOut': instance.checkOut,
};

CheckInOutModel _$CheckInOutModelFromJson(Map<String, dynamic> json) =>
    CheckInOutModel(
      check: json['check'] as String?,
      shift: (json['shift'] as num?)?.toInt(),
      jmlMotor: (json['jmlMotor'] as num).toInt(),
      jmlMobil: (json['jmlMobil'] as num).toInt(),
      alatList: (json['alatList'] as List<dynamic>)
          .map((e) => AlatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CheckInOutModelToJson(CheckInOutModel instance) =>
    <String, dynamic>{
      'check': instance.check,
      'shift': instance.shift,
      'jmlMotor': instance.jmlMotor,
      'jmlMobil': instance.jmlMobil,
      'alatList': instance.alatList,
    };

AlatModel _$AlatModelFromJson(Map<String, dynamic> json) => AlatModel(
  alatId: (json['alatId'] as num).toInt(),
  nama: json['nama'] as String,
  jenis: (json['jenis'] as num).toInt(),
  isChecked: json['isChecked'] as bool,
);

Map<String, dynamic> _$AlatModelToJson(AlatModel instance) => <String, dynamic>{
  'alatId': instance.alatId,
  'nama': instance.nama,
  'jenis': instance.jenis,
  'isChecked': instance.isChecked,
};
