import 'package:equatable/equatable.dart';

class RiwayatAbsensiEntity extends Equatable {
  final DateTime tanggal;
  final String tanggalString;
  final List<ObjekPengawasanEntity> objekList;

  const RiwayatAbsensiEntity({
    required this.tanggal,
    required this.tanggalString,
    required this.objekList,
  });

  @override
  List<Object?> get props => [tanggal, tanggalString, objekList];
}

/// 🚀 Field-nya SENGAJA identik sama AbsensiRecordDummy lama,
/// jadi ObjekAbsensiCard cuma perlu ganti nama tipe.
class ObjekPengawasanEntity extends Equatable {
  final String nop;
  final String namaNop;
  final String? shiftCheckIn;
  final String? shiftCheckOut;
  final String jamCheckIn;
  final String? jamCheckOut;
  final int motorCheckIn;
  final int mobilCheckIn;
  final int? motorCheckOut;
  final int? mobilCheckOut;
  final List<InstrumenTersediaEntity> instrumenCheckIn;
  final List<InstrumenTersediaEntity>? instrumenCheckOut;

  const ObjekPengawasanEntity({
    required this.nop,
    required this.namaNop,
    this.shiftCheckIn,
    this.shiftCheckOut,
    required this.jamCheckIn,
    this.jamCheckOut,
    required this.motorCheckIn,
    required this.mobilCheckIn,
    this.motorCheckOut,
    this.mobilCheckOut,
    this.instrumenCheckIn = const [],
    this.instrumenCheckOut,
  });

  @override
  List<Object?> get props => [
    nop,
    namaNop,
    shiftCheckIn,
    shiftCheckOut,
    jamCheckIn,
    jamCheckOut,
    motorCheckIn,
    mobilCheckIn,
    motorCheckOut,
    mobilCheckOut,
    instrumenCheckIn,
    instrumenCheckOut,
  ];
}

class InstrumenTersediaEntity extends Equatable {
  final String nama;
  final bool tersedia;

  const InstrumenTersediaEntity({required this.nama, required this.tersedia});

  @override
  List<Object?> get props => [nama, tersedia];
}
