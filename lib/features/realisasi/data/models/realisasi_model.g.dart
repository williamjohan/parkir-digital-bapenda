// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realisasi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RealisasiModelImpl _$$RealisasiModelImplFromJson(Map<String, dynamic> json) =>
    _$RealisasiModelImpl(
      enumPajak: (json['enumPajak'] as num?)?.toInt(),
      jenisPajak: json['jenisPajak'] as String?,
      tahun: (json['tahun'] as num?)?.toInt(),
      bulan: (json['bulan'] as num?)?.toInt(),
      bulanNama: json['bulanNama'] as String?,
      akpTarget: json['akpTarget'] as num?,
      realisasi: json['realisasi'] as num?,
      pencapaian: json['pencapaian'] as num?,
      selisih: json['selisih'] as num?,
    );

Map<String, dynamic> _$$RealisasiModelImplToJson(
  _$RealisasiModelImpl instance,
) => <String, dynamic>{
  'enumPajak': instance.enumPajak,
  'jenisPajak': instance.jenisPajak,
  'tahun': instance.tahun,
  'bulan': instance.bulan,
  'bulanNama': instance.bulanNama,
  'akpTarget': instance.akpTarget,
  'realisasi': instance.realisasi,
  'pencapaian': instance.pencapaian,
  'selisih': instance.selisih,
};
