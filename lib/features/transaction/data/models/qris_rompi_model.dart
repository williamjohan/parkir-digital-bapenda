import 'package:json_annotation/json_annotation.dart';

part 'qris_rompi_model.g.dart';

@JsonSerializable()
class QrisRompiModel {
  @JsonKey(name: 'jenisKendaraanId', defaultValue: 0)
  final int jenisKendaraanId;

  @JsonKey(name: 'qrisImageBase64', defaultValue: '')
  final String qrisImageBase64;

  const QrisRompiModel({
    required this.jenisKendaraanId,
    required this.qrisImageBase64,
  });

  factory QrisRompiModel.fromJson(Map<String, dynamic> json) =>
      _$QrisRompiModelFromJson(json);

  Map<String, dynamic> toJson() => _$QrisRompiModelToJson(this);
}
