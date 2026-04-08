// lib/features/auth/data/models/tarif_parkir_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'tarif_parkir_model.g.dart';

String _toString(dynamic value) => value?.toString() ?? '';
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

@JsonSerializable()
class TarifParkirModel {
  @JsonKey(name: 'jenisTarif', fromJson: _toString)
  final String jenisTarif;

  @JsonKey(name: 'tarif', fromJson: _toInt)
  final int tarif;

  const TarifParkirModel({required this.jenisTarif, required this.tarif});

  factory TarifParkirModel.fromJson(Map<String, dynamic> json) =>
      _$TarifParkirModelFromJson(json);

  Map<String, dynamic> toJson() => _$TarifParkirModelToJson(this);

  // 🔥 Method helper untuk konversi ke Map yang aman untuk storage
  Map<String, dynamic> toStorageMap() {
    return {'jenisTarif': jenisTarif, 'tarif': tarif};
  }

  // 🔥 Factory untuk membuat dari Map storage
  factory TarifParkirModel.fromStorageMap(Map<String, dynamic> map) {
    return TarifParkirModel(
      jenisTarif: map['jenisTarif']?.toString() ?? '',
      tarif: (map['tarif'] as num?)?.toInt() ?? 0,
    );
  }
}
