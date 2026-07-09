import 'package:equatable/equatable.dart';

class AbsensiEntity extends Equatable {
  final double latitude;
  final double longitude;
  final int totalMotor;
  final int totalMobil;
  final List<int> detailAlatIds;
  final String fotoPath;
  final bool isCheckIn;

  const AbsensiEntity({
    required this.latitude,
    required this.longitude,
    required this.totalMotor,
    required this.totalMobil,
    required this.detailAlatIds,
    required this.fotoPath,
    required this.isCheckIn,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    totalMotor,
    totalMobil,
    detailAlatIds,
    fotoPath,
    isCheckIn,
  ];
}
