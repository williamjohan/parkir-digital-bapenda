// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_response_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryResponseData _$HistoryResponseDataFromJson(Map<String, dynamic> json) =>
    HistoryResponseData(
      roda2: (json['roda2'] as num?)?.toInt() ?? 0,
      roda4: (json['roda4'] as num?)?.toInt() ?? 0,
      jumlahTransaksi: (json['jumlahTransaksi'] as num?)?.toInt() ?? 0,
      totalPendapatan: (json['totalPendapatan'] as num?)?.toInt() ?? 0,
      detail:
          (json['detail'] as List<dynamic>?)
              ?.map((e) => HistoryItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HistoryResponseDataToJson(
  HistoryResponseData instance,
) => <String, dynamic>{
  'roda2': instance.roda2,
  'roda4': instance.roda4,
  'jumlahTransaksi': instance.jumlahTransaksi,
  'totalPendapatan': instance.totalPendapatan,
  'detail': instance.detail,
};
