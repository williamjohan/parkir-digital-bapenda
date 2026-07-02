import 'package:equatable/equatable.dart';

class AbsensiEntity extends Equatable {
  final DateTime date;
  final bool isPresent;
  final double latitude;
  final double longitude;
  final AbsensiCheckList? checkList;

  const AbsensiEntity({
    required this.date,
    required this.isPresent,
    required this.latitude,
    required this.longitude,
    this.checkList,
  });

  @override
  List<Object?> get props => [date, isPresent, latitude, longitude, checkList];
}

class AbsensiCheckList extends Equatable {
  final bool edc;
  final bool qrisRompi;
  final bool tsPark;
  final int totalMotor;
  final int totalMobil;

  const AbsensiCheckList({
    required this.edc,
    required this.qrisRompi,
    required this.tsPark,
    required this.totalMotor,
    required this.totalMobil,
  });

  @override
  List<Object?> get props => [
    edc,
    qrisRompi,
    tsPark,
    totalMotor,
    totalMobil,
  ];
}
