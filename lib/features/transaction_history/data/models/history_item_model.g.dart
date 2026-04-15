// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryItemModel _$HistoryItemModelFromJson(Map<String, dynamic> json) =>
    HistoryItemModel(
      id: (json['id'] as num).toInt(),
      orderId: json['orderId'] as String? ?? '',
      jenisTarif: json['jenisTarif'] as String? ?? 'FREE',
      sof: json['sof'] as String? ?? 'FREE',
      platNumber: json['platNumber'] as String,
      tglTrx: json['tglTrx'] as String? ?? '',
      kredit: (json['kredit'] as num?)?.toInt() ?? 0,
      namaPetugas: json['namaPetugas'] as String? ?? '',
      modePlat: (json['modePlat'] as num?)?.toInt() ?? 0,
      shift: json['shift'] as String? ?? '-',
    );

Map<String, dynamic> _$HistoryItemModelToJson(HistoryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'jenisTarif': instance.jenisTarif,
      'sof': instance.sof,
      'platNumber': instance.platNumber,
      'tglTrx': instance.tglTrx,
      'kredit': instance.kredit,
      'namaPetugas': instance.namaPetugas,
      'modePlat': instance.modePlat,
      'shift': instance.shift,
    };
