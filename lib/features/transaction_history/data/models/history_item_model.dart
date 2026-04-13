import 'package:json_annotation/json_annotation.dart';

part 'history_item_model.g.dart';

@JsonSerializable()
class HistoryItemModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'orderId', defaultValue: '')
  final String orderId;

  @JsonKey(name: 'jenisTarif', defaultValue: 'FREE')
  final String jenisTarif;

  @JsonKey(name: 'sof', defaultValue: 'FREE')
  final String sof;

  @JsonKey(name: 'platNumber', defaultValue: '-')
  final String platNumber;

  @JsonKey(name: 'tglTrx', defaultValue: '')
  final String tglTrx;

  @JsonKey(name: 'kredit', defaultValue: 0)
  final int kredit;

  @JsonKey(name: 'namaPetugas', defaultValue: '')
  final String namaPetugas;

  @JsonKey(name: 'modePlat', defaultValue: 0)
  final int modePlat;

  HistoryItemModel({
    required this.id,
    required this.orderId,
    required this.jenisTarif,
    required this.sof,
    required this.platNumber,
    required this.tglTrx,
    required this.kredit,
    required this.namaPetugas,
    required this.modePlat,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryItemModelFromJson(json);
}
