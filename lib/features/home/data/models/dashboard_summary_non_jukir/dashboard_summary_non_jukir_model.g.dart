// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_non_jukir_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardSummaryNonJukirModelImpl
_$$DashboardSummaryNonJukirModelImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardSummaryNonJukirModelImpl(
  totalOp: (json['totalOp'] as num?)?.toInt() ?? 0,
  totalOpDigital: (json['totalOpDigital'] as num?)?.toInt() ?? 0,
  totalOpNonDigital: (json['totalOpNonDigital'] as num?)?.toInt() ?? 0,
  jumlahMotorHariIni: (json['jumlahMotorHariIni'] as num?)?.toInt() ?? 0,
  jumlahMobilHariIni: (json['jumlahMobilHariIni'] as num?)?.toInt() ?? 0,
  totalBertarif: (json['totalBertarif'] as num?)?.toInt() ?? 0,
  totalNonTarif: (json['totalNonTarif'] as num?)?.toInt() ?? 0,
  totalTarifTidakDiketahui:
      (json['totalTarifTidakDiketahui'] as num?)?.toInt() ?? 0,
  totalNominalHariIni: (json['totalNominalHariIni'] as num?)?.toDouble() ?? 0.0,
  totalNominalBersihUntukWajibPajak:
      (json['totalNominalBersihUntukWajibPajak'] as num?)?.toDouble() ?? 0.0,
  totalNominalBersihUntukBapenda:
      (json['totalNominalBersihUntukBapenda'] as num?)?.toDouble() ?? 0.0,
  sofParkirResults:
      (json['sofParkirResults'] as List<dynamic>?)
          ?.map((e) => SofParkirResultModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  digital: json['digital'] == null
      ? const OpCategoryModel()
      : OpCategoryModel.fromJson(json['digital'] as Map<String, dynamic>),
  nonDigital: json['nonDigital'] == null
      ? const OpCategoryModel()
      : OpCategoryModel.fromJson(json['nonDigital'] as Map<String, dynamic>),
  persentaseDigital: (json['persentaseDigital'] as num?)?.toDouble() ?? 0.0,
  persentaseNonDigital:
      (json['persentaseNonDigital'] as num?)?.toDouble() ?? 0.0,
  detail: json['detail'] == null
      ? const DetailModel()
      : DetailModel.fromJson(json['detail'] as Map<String, dynamic>),
  berbayar: json['berbayar'] == null
      ? const BerbayarModel()
      : BerbayarModel.fromJson(json['berbayar'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$DashboardSummaryNonJukirModelImplToJson(
  _$DashboardSummaryNonJukirModelImpl instance,
) => <String, dynamic>{
  'totalOp': instance.totalOp,
  'totalOpDigital': instance.totalOpDigital,
  'totalOpNonDigital': instance.totalOpNonDigital,
  'jumlahMotorHariIni': instance.jumlahMotorHariIni,
  'jumlahMobilHariIni': instance.jumlahMobilHariIni,
  'totalBertarif': instance.totalBertarif,
  'totalNonTarif': instance.totalNonTarif,
  'totalTarifTidakDiketahui': instance.totalTarifTidakDiketahui,
  'totalNominalHariIni': instance.totalNominalHariIni,
  'totalNominalBersihUntukWajibPajak':
      instance.totalNominalBersihUntukWajibPajak,
  'totalNominalBersihUntukBapenda': instance.totalNominalBersihUntukBapenda,
  'sofParkirResults': instance.sofParkirResults,
  'digital': instance.digital,
  'nonDigital': instance.nonDigital,
  'persentaseDigital': instance.persentaseDigital,
  'persentaseNonDigital': instance.persentaseNonDigital,
  'detail': instance.detail,
  'berbayar': instance.berbayar,
};

_$SofParkirResultModelImpl _$$SofParkirResultModelImplFromJson(
  Map<String, dynamic> json,
) => _$SofParkirResultModelImpl(
  sof: json['sof'] as String? ?? '',
  nominalMotor: (json['nominalMotor'] as num?)?.toDouble() ?? 0.0,
  nominalMobil: (json['nominalMobil'] as num?)?.toDouble() ?? 0.0,
  nominalBersihUntukWajibPajakMotor:
      (json['nominalBersihUntukWajibPajakMotor'] as num?)?.toDouble() ?? 0.0,
  nominalBersihUntukWajibPajakMobil:
      (json['nominalBersihUntukWajibPajakMobil'] as num?)?.toDouble() ?? 0.0,
  nominalBersihUntukBapendaMotor:
      (json['nominalBersihUntukBapendaMotor'] as num?)?.toDouble() ?? 0.0,
  nominalBersihUntukBapendaMobil:
      (json['nominalBersihUntukBapendaMobil'] as num?)?.toDouble() ?? 0.0,
  jumlahMotor: (json['jumlahMotor'] as num?)?.toInt() ?? 0,
  jumlahMobil: (json['jumlahMobil'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$SofParkirResultModelImplToJson(
  _$SofParkirResultModelImpl instance,
) => <String, dynamic>{
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

_$OpCategoryModelImpl _$$OpCategoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$OpCategoryModelImpl(
  total: (json['total'] as num?)?.toInt() ?? 0,
  totalBertarif: (json['totalBertarif'] as num?)?.toInt() ?? 0,
  totalNonTarif: (json['totalNonTarif'] as num?)?.toInt() ?? 0,
  totalTidakDiketahui: (json['totalTidakDiketahui'] as num?)?.toInt() ?? 0,
  persentaseBertarif: (json['persentaseBertarif'] as num?)?.toDouble() ?? 0.0,
  persentaseNonTarif: (json['persentaseNonTarif'] as num?)?.toDouble() ?? 0.0,
  persentaseTidakDiketahui:
      (json['persentaseTidakDiketahui'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$OpCategoryModelImplToJson(
  _$OpCategoryModelImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'totalBertarif': instance.totalBertarif,
  'totalNonTarif': instance.totalNonTarif,
  'totalTidakDiketahui': instance.totalTidakDiketahui,
  'persentaseBertarif': instance.persentaseBertarif,
  'persentaseNonTarif': instance.persentaseNonTarif,
  'persentaseTidakDiketahui': instance.persentaseTidakDiketahui,
};

_$DetailModelImpl _$$DetailModelImplFromJson(Map<String, dynamic> json) =>
    _$DetailModelImpl(
      totalEdc: (json['totalEdc'] as num?)?.toInt() ?? 0,
      totalRompiQris: (json['totalRompiQris'] as num?)?.toInt() ?? 0,
      totalCctvCounting: (json['totalCctvCounting'] as num?)?.toInt() ?? 0,
      totalTs: (json['totalTs'] as num?)?.toInt() ?? 0,
      totalBebasParkir: (json['totalBebasParkir'] as num?)?.toInt() ?? 0,
      totalNonDigital: (json['totalNonDigital'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DetailModelImplToJson(_$DetailModelImpl instance) =>
    <String, dynamic>{
      'totalEdc': instance.totalEdc,
      'totalRompiQris': instance.totalRompiQris,
      'totalCctvCounting': instance.totalCctvCounting,
      'totalTs': instance.totalTs,
      'totalBebasParkir': instance.totalBebasParkir,
      'totalNonDigital': instance.totalNonDigital,
    };

_$BerbayarModelImpl _$$BerbayarModelImplFromJson(Map<String, dynamic> json) =>
    _$BerbayarModelImpl(
      digital: (json['digital'] as num?)?.toInt() ?? 0,
      nonDigital: (json['nonDigital'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      persentase: (json['persentase'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$BerbayarModelImplToJson(_$BerbayarModelImpl instance) =>
    <String, dynamic>{
      'digital': instance.digital,
      'nonDigital': instance.nonDigital,
      'total': instance.total,
      'persentase': instance.persentase,
    };
