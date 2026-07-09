import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tarif_model.g.dart';

double _toDouble(dynamic value) => (value ?? 0).toDouble();

@JsonSerializable()
class TarifModel extends Equatable {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: '')
  final String jenisTarif;

  @JsonKey(fromJson: _toDouble)
  final double tarif;

  const TarifModel({
    required this.id,
    required this.jenisTarif,
    required this.tarif,
  });

  factory TarifModel.fromJson(Map<String, dynamic> json) =>
      _$TarifModelFromJson(json);

  Map<String, dynamic> toJson() => _$TarifModelToJson(this);

  @override
  List<Object?> get props => [id, jenisTarif, tarif];
}
