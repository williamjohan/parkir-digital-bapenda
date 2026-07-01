import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'alat_item_model.dart';

part 'checkout_model.g.dart';

// NOTE: Field JSON di bawah ini aku asumsikan simetris dengan endpoint
// check-in (CheckInJmlMobil -> CheckOutJmlMobil, dst) karena screenshot
// Swagger yang dikirim cuma buat endpoint check-in. Tolong dicek lagi ke
// dokumentasi/endpoint check-out yang asli, tinggal sesuaikan @JsonKey-nya.
@JsonSerializable()
class CheckOutModel extends Equatable {
  @JsonKey(name: 'CheckOutJmlMobil')
  final double checkOutJmlMobil;

  @JsonKey(name: 'CheckOutJmlMotor')
  final double checkOutJmlMotor;

  @JsonKey(name: 'Latitude')
  final String latitude;

  @JsonKey(name: 'Longitude')
  final String longitude;

  @JsonKey(name: 'DetailAlatList')
  final List<AlatItemModel> detailAlatList;

  const CheckOutModel({
    required this.checkOutJmlMobil,
    required this.checkOutJmlMotor,
    required this.latitude,
    required this.longitude,
    required this.detailAlatList,
  });

  factory CheckOutModel.fromJson(Map<String, dynamic> json) =>
      _$CheckOutModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckOutModelToJson(this);

  @override
  List<Object?> get props => [
    checkOutJmlMobil,
    checkOutJmlMotor,
    latitude,
    longitude,
    detailAlatList,
  ];
}
