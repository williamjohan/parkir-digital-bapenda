import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alat_item_model.g.dart';

@JsonSerializable()
class AlatItemModel extends Equatable {
  @JsonKey(name: 'id')
  final int id;

  const AlatItemModel({required this.id});

  factory AlatItemModel.fromJson(Map<String, dynamic> json) =>
      _$AlatItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlatItemModelToJson(this);

  @override
  List<Object?> get props => [id];
}
