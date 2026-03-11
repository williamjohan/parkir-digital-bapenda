import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'id_jukir', defaultValue: '')
  final String idJukir;

  @JsonKey(name: 'nama', defaultValue: '')
  final String nama;

  @JsonKey(name: 'nop', defaultValue: '')
  final String nop;

  UserModel({required this.idJukir, required this.nama, required this.nop});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
