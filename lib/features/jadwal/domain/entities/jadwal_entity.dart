import 'package:equatable/equatable.dart';

class JadwalEntity extends Equatable {
  final int hari;
  final String hariNama;
  final int bulan;
  final String bulanNama;
  final int tahun;
  final String tahunNama;
  final String jamMasuk;
  final String jamPulang;
  final String jamCheckIn;
  final String jamCheckOut;
  final bool isLibur;

  const JadwalEntity({
    required this.hari,
    required this.hariNama,
    required this.bulan,
    required this.bulanNama,
    required this.tahun,
    required this.tahunNama,
    required this.jamMasuk,
    required this.jamPulang,
    required this.jamCheckIn,
    required this.jamCheckOut,
    required this.isLibur,
  });

  @override
  List<Object?> get props => [
    hari,
    hariNama,
    bulan,
    bulanNama,
    tahun,
    tahunNama,
    jamMasuk,
    jamPulang,
    jamCheckIn,
    jamCheckOut,
    isLibur,
  ];
}
