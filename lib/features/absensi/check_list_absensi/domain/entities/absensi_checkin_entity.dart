import 'package:equatable/equatable.dart';

/// Item alat/instrumen (EDC, QRIS, TSpark, dll) yang dicentang di form.
/// `id` mengacu ke id instrumen di master data.
class AlatEntity extends Equatable {
  final int id;

  const AlatEntity({required this.id});

  @override
  List<Object?> get props => [id];
}

class CheckInEntity extends Equatable {
  final double jumlahMobil;
  final double jumlahMotor;
  final String latitude;
  final String longitude;
  final List<AlatEntity> detailAlat;

  const CheckInEntity({
    required this.jumlahMobil,
    required this.jumlahMotor,
    required this.latitude,
    required this.longitude,
    required this.detailAlat,
  });

  @override
  List<Object?> get props => [
    jumlahMobil,
    jumlahMotor,
    latitude,
    longitude,
    detailAlat,
  ];
}

class CheckOutEntity extends Equatable {
  final double jumlahMobil;
  final double jumlahMotor;
  final String latitude;
  final String longitude;
  final List<AlatEntity> detailAlat;

  const CheckOutEntity({
    required this.jumlahMobil,
    required this.jumlahMotor,
    required this.latitude,
    required this.longitude,
    required this.detailAlat,
  });

  @override
  List<Object?> get props => [
    jumlahMobil,
    jumlahMotor,
    latitude,
    longitude,
    detailAlat,
  ];
}
