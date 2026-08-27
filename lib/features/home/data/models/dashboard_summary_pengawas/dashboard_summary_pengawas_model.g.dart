// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_pengawas_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailAlatModel _$DetailAlatModelFromJson(Map<String, dynamic> json) =>
    DetailAlatModel(
      alatId: (json['alatId'] as num?)?.toInt() ?? 0,
      nama: json['nama'] as String? ?? '',
      jenis: (json['jenis'] as num?)?.toInt() ?? 0,
      isBawa: json['isChecked'] as bool? ?? true,
    );

Map<String, dynamic> _$DetailAlatModelToJson(DetailAlatModel instance) =>
    <String, dynamic>{
      'alatId': instance.alatId,
      'nama': instance.nama,
      'jenis': instance.jenis,
      'isChecked': instance.isBawa,
    };

_$DashboardSummaryPengawasModelImpl
_$$DashboardSummaryPengawasModelImplFromJson(Map<String, dynamic> json) =>
    _$DashboardSummaryPengawasModelImpl(
      isSuccess: json['isSuccess'] as bool? ?? false,
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? const DashboardDataModel()
          : DashboardDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DashboardSummaryPengawasModelImplToJson(
  _$DashboardSummaryPengawasModelImpl instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

_$DashboardDataModelImpl _$$DashboardDataModelImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardDataModelImpl(
  laporanPelanggaran: (json['laporanPelanggaran'] as num?)?.toInt() ?? 0,
  pengawasanSequence: (json['pengawasanSequence'] as num?)?.toInt() ?? 0,
  dashboard: json['dashboard'] == null
      ? const DashboardInfoModel()
      : DashboardInfoModel.fromJson(json['dashboard'] as Map<String, dynamic>),
  checkInOut: json['checkInOut'] == null
      ? const CheckInOutModel()
      : CheckInOutModel.fromJson(json['checkInOut'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$DashboardDataModelImplToJson(
  _$DashboardDataModelImpl instance,
) => <String, dynamic>{
  'laporanPelanggaran': instance.laporanPelanggaran,
  'pengawasanSequence': instance.pengawasanSequence,
  'dashboard': instance.dashboard,
  'checkInOut': instance.checkInOut,
};

_$DashboardInfoModelImpl _$$DashboardInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardInfoModelImpl(
  jumlahMotorHariIni: (json['jumlahMotorHariIni'] as num?)?.toInt() ?? 0,
  jumlahMobilHariIni: (json['jumlahMobilHariIni'] as num?)?.toInt() ?? 0,
  totalNominalHariIni: (json['totalNominalHariIni'] as num?)?.toInt() ?? 0,
  totalNominalBersihUntukWajibPajak:
      (json['totalNominalBersihUntukWajibPajak'] as num?)?.toInt() ?? 0,
  totalNominalBersihUntukBapenda:
      (json['totalNominalBersihUntukBapenda'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$DashboardInfoModelImplToJson(
  _$DashboardInfoModelImpl instance,
) => <String, dynamic>{
  'jumlahMotorHariIni': instance.jumlahMotorHariIni,
  'jumlahMobilHariIni': instance.jumlahMobilHariIni,
  'totalNominalHariIni': instance.totalNominalHariIni,
  'totalNominalBersihUntukWajibPajak':
      instance.totalNominalBersihUntukWajibPajak,
  'totalNominalBersihUntukBapenda': instance.totalNominalBersihUntukBapenda,
};

_$CheckInOutModelImpl _$$CheckInOutModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckInOutModelImpl(
  idEvent: (json['idEvent'] as num?)?.toInt() ?? 0,
  op: json['op'] as String? ?? '',
  nip: json['nip'] as String? ?? '',
  tglRoster: json['tglRoster'] as String? ?? '',
  jadwalMasuk: json['jadwalMasuk'] as String? ?? '',
  jadwalOut: json['jadwalOut'] as String? ?? '',
  status: (json['status'] as num?)?.toInt() ?? 0,
  checkIn: json['checkIn'] as String? ?? '',
  checkInString: json['checkInString'] as String? ?? '',
  checkInJmlMobil: (json['checkInJmlMobil'] as num?)?.toInt() ?? 0,
  checkInJmlMotor: (json['checkInJmlMotor'] as num?)?.toInt() ?? 0,
  checkOut: json['checkOut'] as String? ?? '',
  checkOutString: json['checkOutString'] as String? ?? '',
  checkOutJmlMobil: (json['checkOutJmlMobil'] as num?)?.toInt() ?? 0,
  checkOutJmlMotor: (json['checkOutJmlMotor'] as num?)?.toInt() ?? 0,
  latitude: json['latitude'] as String? ?? '',
  longitude: json['longitude'] as String? ?? '',
  detailAlatCheckIn:
      (json['detailAlatCheckIn'] as List<dynamic>?)
          ?.map((e) => DetailAlatModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  detailAlatCheckOut:
      (json['detailAlatCheckOut'] as List<dynamic>?)
          ?.map((e) => DetailAlatModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CheckInOutModelImplToJson(
  _$CheckInOutModelImpl instance,
) => <String, dynamic>{
  'idEvent': instance.idEvent,
  'op': instance.op,
  'nip': instance.nip,
  'tglRoster': instance.tglRoster,
  'jadwalMasuk': instance.jadwalMasuk,
  'jadwalOut': instance.jadwalOut,
  'status': instance.status,
  'checkIn': instance.checkIn,
  'checkInString': instance.checkInString,
  'checkInJmlMobil': instance.checkInJmlMobil,
  'checkInJmlMotor': instance.checkInJmlMotor,
  'checkOut': instance.checkOut,
  'checkOutString': instance.checkOutString,
  'checkOutJmlMobil': instance.checkOutJmlMobil,
  'checkOutJmlMotor': instance.checkOutJmlMotor,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'detailAlatCheckIn': instance.detailAlatCheckIn,
  'detailAlatCheckOut': instance.detailAlatCheckOut,
};
