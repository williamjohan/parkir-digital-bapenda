import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_jukir_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DataJukirModel extends Equatable {
  @JsonKey(defaultValue: '')
  final String idDevice;

  @JsonKey(defaultValue: '')
  final String petugas;

  @JsonKey(defaultValue: '')
  final String shift;

  @JsonKey(defaultValue: 0)
  final int totalMobilHariIni;

  @JsonKey(defaultValue: 0)
  final int totalMotorHariIni;

  @JsonKey(defaultValue: 0)
  final int totalNominalMobilHariIni;

  @JsonKey(defaultValue: 0)
  final int totalNominalMotorHariIni;

  @JsonKey(defaultValue: 0)
  final int totalKendaraan;

  @JsonKey(defaultValue: 0)
  final int totalNominal;

  @JsonKey(defaultValue: [])
  final List<UsernameModel> usernameList;

  const DataJukirModel({
    required this.idDevice,
    required this.petugas,
    required this.shift,
    required this.totalMobilHariIni,
    required this.totalMotorHariIni,
    required this.totalNominalMobilHariIni,
    required this.totalNominalMotorHariIni,
    required this.totalKendaraan,
    required this.totalNominal,
    required this.usernameList,
  });

  factory DataJukirModel.fromJson(Map<String, dynamic> json) =>
      _$DataJukirModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataJukirModelToJson(this);

  @override
  List<Object?> get props => [
    idDevice,
    petugas,
    shift,
    totalMobilHariIni,
    totalMotorHariIni,
    totalNominalMobilHariIni,
    totalNominalMotorHariIni,
    totalKendaraan,
    totalNominal,
    usernameList,
  ];
}

@JsonSerializable()
class UsernameModel extends Equatable {
  @JsonKey(defaultValue: '')
  final String username;

  @JsonKey(defaultValue: '')
  final String namaPetugas;

  @JsonKey(defaultValue: '')
  final String fotoBase64;

  const UsernameModel({
    required this.username,
    required this.namaPetugas,
    required this.fotoBase64,
  });

  factory UsernameModel.fromJson(Map<String, dynamic> json) =>
      _$UsernameModelFromJson(json);

  Map<String, dynamic> toJson() => _$UsernameModelToJson(this);

  @override
  List<Object?> get props => [username, namaPetugas, fotoBase64];
}
