part of 'detail_realisasi_op_model.dart';

_$DetailRealisasiOpResponseImpl _$$DetailRealisasiOpResponseImplFromJson(
  Map<String, dynamic> json,
) => _$DetailRealisasiOpResponseImpl(
  isSuccess: json['isSuccess'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : DetailRealisasiOpModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$DetailRealisasiOpResponseImplToJson(
  _$DetailRealisasiOpResponseImpl instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

_$DetailRealisasiOpModelImpl _$$DetailRealisasiOpModelImplFromJson(
  Map<String, dynamic> json,
) => _$DetailRealisasiOpModelImpl(
  nop: json['nop'] as String?,
  namaOp: json['namaOp'] as String?,
  uptbId: (json['uptbId'] as num?)?.toInt(),
  tahun: (json['tahun'] as num?)?.toInt(),
  isDigital: json['isDigital'] as bool?,
  tglDigitalisasi: json['tglDigitalisasi'] as String?,
  nominalNonDigital: (json['nominalNonDigital'] as num?)?.toDouble(),
  nominalDigital: (json['nominalDigital'] as num?)?.toDouble(),
  totalNominal: (json['totalNominal'] as num?)?.toDouble(),
  realisasiPerBulan: (json['realisasiPerBulan'] as List<dynamic>?)
      ?.map((e) => RealisasiPerBulanModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$DetailRealisasiOpModelImplToJson(
  _$DetailRealisasiOpModelImpl instance,
) => <String, dynamic>{
  'nop': instance.nop,
  'namaOp': instance.namaOp,
  'uptbId': instance.uptbId,
  'tahun': instance.tahun,
  'isDigital': instance.isDigital,
  'tglDigitalisasi': instance.tglDigitalisasi,
  'nominalNonDigital': instance.nominalNonDigital,
  'nominalDigital': instance.nominalDigital,
  'totalNominal': instance.totalNominal,
  'realisasiPerBulan': instance.realisasiPerBulan,
};

_$RealisasiPerBulanModelImpl _$$RealisasiPerBulanModelImplFromJson(
  Map<String, dynamic> json,
) => _$RealisasiPerBulanModelImpl(
  bulan: (json['bulan'] as num?)?.toInt(),
  bulanNama: json['bulanNama'] as String?,
  tglSspd: json['tglSspd'] as String?,
  nominalNonDigital: (json['nominalNonDigital'] as num?)?.toDouble(),
  nominalDigital: (json['nominalDigital'] as num?)?.toDouble(),
  totalNominal: (json['totalNominal'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$RealisasiPerBulanModelImplToJson(
  _$RealisasiPerBulanModelImpl instance,
) => <String, dynamic>{
  'bulan': instance.bulan,
  'bulanNama': instance.bulanNama,
  'tglSspd': instance.tglSspd,
  'nominalNonDigital': instance.nominalNonDigital,
  'nominalDigital': instance.nominalDigital,
  'totalNominal': instance.totalNominal,
};
