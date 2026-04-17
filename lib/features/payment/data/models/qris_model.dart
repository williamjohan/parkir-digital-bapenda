import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/qris_entity.dart';

part 'qris_model.g.dart';

@JsonSerializable()
class QrisModel {
  final String kodeQris;
  final String qrisValue;
  final String qrisBase64;
  final String nmid;
  final String nameQris;
  final int nominal;
  final int expTimeMenit;

  QrisModel({
    required this.kodeQris,
    required this.qrisValue,
    required this.qrisBase64,
    required this.nmid,
    required this.nameQris,
    required this.nominal,
    required this.expTimeMenit,
  });

  factory QrisModel.fromJson(Map<String, dynamic> json) =>
      _$QrisModelFromJson(json);

  Map<String, dynamic> toJson() => _$QrisModelToJson(this);

  /// 🚀 MAPPING: Mengubah Model (Data) menjadi Entity (Domain)
  QrisEntity toEntity() => QrisEntity(
    kodeQris: kodeQris,
    qrisValue: qrisValue,
    qrisBase64: qrisBase64,
    nmid: nmid,
    nameQris: nameQris,
    nominal: nominal,
    expTimeMenit: expTimeMenit,
  );
}
