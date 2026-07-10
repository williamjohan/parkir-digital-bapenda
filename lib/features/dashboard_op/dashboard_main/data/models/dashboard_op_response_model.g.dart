// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_op_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardOpResponseModelImpl _$$DashboardOpResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardOpResponseModelImpl(
  nop: json['nop'] as String,
  namaOp: json['namaOp'] as String,
  uptbId: (json['uptbId'] as num).toInt(),
  isDigital: json['isDigital'] as bool,
  pendapatanHariIniKotor: (json['pendapatanHariIniKotor'] as num).toInt(),
  pendapatanHariIniBersihWajibPajak:
      (json['pendapatanHariIniBersihWajibPajak'] as num).toInt(),
  pendapatanHariIniBersihBapenda:
      (json['pendapatanHariIniBersihBapenda'] as num).toInt(),
  totalTransaksiRodaDua: (json['totalTransaksiRodaDua'] as num).toInt(),
  totalTransaksiRodaEmpat: (json['totalTransaksiRodaEmpat'] as num).toInt(),
  realisasiTahunIni: RealisasiTahunIniModel.fromJson(
    json['realisasiTahunIni'] as Map<String, dynamic>,
  ),
  riwayatList: (json['riwayatList'] as List<dynamic>)
      .map((e) => RiwayatPendapatanModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  sofList: (json['sofList'] as List<dynamic>)
      .map((e) => SofModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  tarifMotor: (json['tarifMotor'] as num).toInt(),
  tarifMobil: (json['tarifMobil'] as num).toInt(),
  jadwalOperasional: json['jadwalOperasional'] as String,
);

Map<String, dynamic> _$$DashboardOpResponseModelImplToJson(
  _$DashboardOpResponseModelImpl instance,
) => <String, dynamic>{
  'nop': instance.nop,
  'namaOp': instance.namaOp,
  'uptbId': instance.uptbId,
  'isDigital': instance.isDigital,
  'pendapatanHariIniKotor': instance.pendapatanHariIniKotor,
  'pendapatanHariIniBersihWajibPajak':
      instance.pendapatanHariIniBersihWajibPajak,
  'pendapatanHariIniBersihBapenda': instance.pendapatanHariIniBersihBapenda,
  'totalTransaksiRodaDua': instance.totalTransaksiRodaDua,
  'totalTransaksiRodaEmpat': instance.totalTransaksiRodaEmpat,
  'realisasiTahunIni': instance.realisasiTahunIni,
  'riwayatList': instance.riwayatList,
  'sofList': instance.sofList,
  'tarifMotor': instance.tarifMotor,
  'tarifMobil': instance.tarifMobil,
  'jadwalOperasional': instance.jadwalOperasional,
};

_$RealisasiTahunIniModelImpl _$$RealisasiTahunIniModelImplFromJson(
  Map<String, dynamic> json,
) => _$RealisasiTahunIniModelImpl(
  nonDigital: (json['nonDigital'] as num).toInt(),
  digital: (json['digital'] as num).toInt(),
  realisasi: (json['realisasi'] as num).toInt(),
);

Map<String, dynamic> _$$RealisasiTahunIniModelImplToJson(
  _$RealisasiTahunIniModelImpl instance,
) => <String, dynamic>{
  'nonDigital': instance.nonDigital,
  'digital': instance.digital,
  'realisasi': instance.realisasi,
};

_$RiwayatPendapatanModelImpl _$$RiwayatPendapatanModelImplFromJson(
  Map<String, dynamic> json,
) => _$RiwayatPendapatanModelImpl(
  jenisKendaraan: json['jenisKendaraan'] as String,
  tgl: json['tgl'] as String,
  kredit: (json['kredit'] as num).toInt(),
);

Map<String, dynamic> _$$RiwayatPendapatanModelImplToJson(
  _$RiwayatPendapatanModelImpl instance,
) => <String, dynamic>{
  'jenisKendaraan': instance.jenisKendaraan,
  'tgl': instance.tgl,
  'kredit': instance.kredit,
};

_$SofModelImpl _$$SofModelImplFromJson(Map<String, dynamic> json) =>
    _$SofModelImpl(
      sof: json['sof'] as String,
      nominalMotor: (json['nominalMotor'] as num).toInt(),
      nominalMobil: (json['nominalMobil'] as num).toInt(),
      nominalBersihUntukWajibPajakMotor:
          (json['nominalBersihUntukWajibPajakMotor'] as num).toInt(),
      nominalBersihUntukWajibPajakMobil:
          (json['nominalBersihUntukWajibPajakMobil'] as num).toInt(),
      nominalBersihUntukBapendaMotor:
          (json['nominalBersihUntukBapendaMotor'] as num).toInt(),
      nominalBersihUntukBapendaMobil:
          (json['nominalBersihUntukBapendaMobil'] as num).toInt(),
      jumlahMotor: (json['jumlahMotor'] as num).toInt(),
      jumlahMobil: (json['jumlahMobil'] as num).toInt(),
    );

Map<String, dynamic> _$$SofModelImplToJson(_$SofModelImpl instance) =>
    <String, dynamic>{
      'sof': instance.sof,
      'nominalMotor': instance.nominalMotor,
      'nominalMobil': instance.nominalMobil,
      'nominalBersihUntukWajibPajakMotor':
          instance.nominalBersihUntukWajibPajakMotor,
      'nominalBersihUntukWajibPajakMobil':
          instance.nominalBersihUntukWajibPajakMobil,
      'nominalBersihUntukBapendaMotor': instance.nominalBersihUntukBapendaMotor,
      'nominalBersihUntukBapendaMobil': instance.nominalBersihUntukBapendaMobil,
      'jumlahMotor': instance.jumlahMotor,
      'jumlahMobil': instance.jumlahMobil,
    };
