import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_pengawasan_model.g.dart';

@JsonSerializable()
class AddPengawasanModel extends Equatable {
  @JsonKey(name: 'JenisPel')
  final int jenisPel;

  @JsonKey(name: 'KetPel')
  final String ketPel;

  const AddPengawasanModel({required this.jenisPel, required this.ketPel});

  factory AddPengawasanModel.fromJson(Map<String, dynamic> json) =>
      _$AddPengawasanModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddPengawasanModelToJson(this);

  @override
  List<Object?> get props => [jenisPel, ketPel];
}
