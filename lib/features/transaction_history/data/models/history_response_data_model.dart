import 'package:json_annotation/json_annotation.dart';
import 'history_item_model.dart';

part 'history_response_data_model.g.dart';

double _toDouble(dynamic value) => (value ?? 0).toDouble();

@JsonSerializable()
class HistoryResponseData {
  @JsonKey(name: 'roda2', defaultValue: 0)
  final int roda2;

  @JsonKey(name: 'roda4', defaultValue: 0)
  final int roda4;

  @JsonKey(name: 'jumlahTransaksi', defaultValue: 0)
  final int jumlahTransaksi;

  @JsonKey(name: 'totalPendapatan', defaultValue: 0)
  final int totalPendapatan;

  @JsonKey(name: 'totalPendapatanWajibPajak', fromJson: _toDouble)
  final double totalPendapatanWajibPajak;

  @JsonKey(name: 'totalPendapatanBapenda', fromJson: _toDouble)
  final double totalPendapatanBapenda;

  @JsonKey(name: 'detail', defaultValue: [])
  final List<HistoryItemModel> detail;

  HistoryResponseData({
    required this.roda2,
    required this.roda4,
    required this.jumlahTransaksi,
    required this.totalPendapatan,
    required this.totalPendapatanWajibPajak,
    required this.totalPendapatanBapenda,
    required this.detail,
  });

  factory HistoryResponseData.fromJson(Map<String, dynamic> json) =>
      _$HistoryResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryResponseDataToJson(this);
}
