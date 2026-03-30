// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  idUser: json['idUser'] as String? ?? '',
  namaUser: json['namaUser'] as String? ?? '',
  nop: json['nop'] as String? ?? '',
  namaObjekPajak: json['namaObjekPajak'] as String? ?? '',
  alamat: json['alamat'] as String? ?? '',
  pungutTarif: (json['pungutTarif'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'idUser': instance.idUser,
  'namaUser': instance.namaUser,
  'nop': instance.nop,
  'namaObjekPajak': instance.namaObjekPajak,
  'alamat': instance.alamat,
  'pungutTarif': instance.pungutTarif,
};
