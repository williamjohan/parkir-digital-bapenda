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
