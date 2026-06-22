import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_jukir_model.g.dart';

@JsonSerializable()
class DataJukirModel extends Equatable {
  @JsonKey(defaultValue: '')
  final String nop;

  @JsonKey(defaultValue: '')
  final String username;

  @JsonKey(defaultValue: '')
  final String idDevice;

  @JsonKey(defaultValue: '')
  final String nopFormatted;

  @JsonKey(defaultValue: '')
  final String namaPetugas;

  const DataJukirModel({
    required this.nop,
    required this.username,
    required this.idDevice,
    required this.nopFormatted,
    required this.namaPetugas,
  });

  factory DataJukirModel.fromJson(Map<String, dynamic> json) =>
      _$DataJukirModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataJukirModelToJson(this);

  @override
  List<Object?> get props => [
    nop,
    username,
    idDevice,
    nopFormatted,
    namaPetugas,
  ];
}
