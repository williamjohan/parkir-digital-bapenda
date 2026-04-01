// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  idUser: _toString(json['idUser']),
  namaUser: _toString(json['namaUser']),
  nop: _toString(json['nop']),
  namaObjekPajak: json['namaObjekPajak'] == null
      ? ''
      : _toString(json['namaObjekPajak']),
  alamat: json['alamat'] == null ? '' : _toString(json['alamat']),
  pungutTarif: json['pungutTarif'] == null ? 0 : _toInt(json['pungutTarif']),
  lokasiId: json['lokasiId'] == null ? 0 : _toInt(json['lokasiId']),
  namaLokasi: json['namaLokasi'] == null ? '' : _toString(json['namaLokasi']),
  kodeGate: json['kodeGate'] == null ? '' : _toString(json['kodeGate']),
  namaGate: json['namaGate'] == null ? '' : _toString(json['namaGate']),
  idDevice: json['idDevice'] == null ? '' : _toString(json['idDevice']),
  shift: json['shift'] == null ? '' : _toString(json['shift']),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'idUser': instance.idUser,
  'namaUser': instance.namaUser,
  'nop': instance.nop,
  'namaObjekPajak': instance.namaObjekPajak,
  'alamat': instance.alamat,
  'pungutTarif': instance.pungutTarif,
  'lokasiId': instance.lokasiId,
  'namaLokasi': instance.namaLokasi,
  'kodeGate': instance.kodeGate,
  'namaGate': instance.namaGate,
  'idDevice': instance.idDevice,
  'shift': instance.shift,
};
