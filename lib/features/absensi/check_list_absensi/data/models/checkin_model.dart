import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'alat_item_model.dart';

part 'checkin_model.g.dart';

@JsonSerializable()
class CheckInModel extends Equatable {
  @JsonKey(name: 'CheckInJmlMobil')
  final double checkInJmlMobil;

  @JsonKey(name: 'CheckInJmlMotor')
  final double checkInJmlMotor;

  @JsonKey(name: 'Latitude')
  final String latitude;

  @JsonKey(name: 'Longitude')
  final String longitude;

  @JsonKey(name: 'DetailAlatList')
  final List<AlatItemModel> detailAlatList;

  const CheckInModel({
    required this.checkInJmlMobil,
    required this.checkInJmlMotor,
    required this.latitude,
    required this.longitude,
    required this.detailAlatList,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) =>
      _$CheckInModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInModelToJson(this);

  @override
  List<Object?> get props => [
    checkInJmlMobil,
    checkInJmlMotor,
    latitude,
    longitude,
    detailAlatList,
  ];
}
