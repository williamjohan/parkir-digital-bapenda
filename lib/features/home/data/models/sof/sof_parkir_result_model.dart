import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sof_parkir_result_model.g.dart';

double _toDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is double) return value;
  if (value is int) return value.toDouble();

  return double.tryParse(value.toString()) ?? 0.0;
}

@JsonSerializable()
class SofParkirResultModel extends Equatable {
  final String sof;

  @JsonKey(fromJson: _toDouble)
  final double nominalMotor;

  @JsonKey(fromJson: _toDouble)
  final double nominalMobil;

  @JsonKey(fromJson: _toDouble)
  final double nominalBersihUntukWajibPajakMotor;

  @JsonKey(fromJson: _toDouble)
  final double nominalBersihUntukWajibPajakMobil;

  @JsonKey(fromJson: _toDouble)
  final double nominalBersihUntukBapendaMotor;

  @JsonKey(fromJson: _toDouble)
  final double nominalBersihUntukBapendaMobil;

  @JsonKey(defaultValue: 0)
  final int jumlahMotor;

  @JsonKey(defaultValue: 0)
  final int jumlahMobil;

  const SofParkirResultModel({
    required this.sof,
    required this.nominalMotor,
    required this.nominalMobil,
    required this.nominalBersihUntukWajibPajakMotor,
    required this.nominalBersihUntukWajibPajakMobil,
    required this.nominalBersihUntukBapendaMotor,
    required this.nominalBersihUntukBapendaMobil,
    required this.jumlahMotor,
    required this.jumlahMobil,
  });

  factory SofParkirResultModel.fromJson(Map<String, dynamic> json) =>
      _$SofParkirResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$SofParkirResultModelToJson(this);

  @override
  List<Object?> get props => [
    sof,
    nominalMotor,
    nominalMobil,
    nominalBersihUntukWajibPajakMotor,
    nominalBersihUntukWajibPajakMobil,
    nominalBersihUntukBapendaMotor,
    nominalBersihUntukBapendaMobil,
    jumlahMotor,
    jumlahMobil,
  ];
}
