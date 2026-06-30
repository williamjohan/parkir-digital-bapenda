import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String idUser; // Sekarang String (sesuai UserModel)
  final String namaUser;
  final String username;
  final String nop;
  final int pungutTarif;
  final String pungutTarifDescription;
  final String namaObjekPajak;
  final int lokasiId; // Sekarang int (sesuai UserModel)
  final String namaLokasi;
  final String kodeGate;
  final String namaGate;
  final String idDevice;
  final String shift;
  final String alamat;

  const UserEntity({
    required this.idUser,
    required this.namaUser,
    required this.username,
    required this.nop,
    required this.pungutTarif,
    required this.pungutTarifDescription,
    required this.namaObjekPajak,
    required this.lokasiId,
    required this.namaLokasi,
    required this.kodeGate,
    required this.namaGate,
    required this.idDevice,
    required this.shift,
    required this.alamat,
  });

  @override
  List<Object?> get props => [
    idUser,
    namaUser,
    username,
    nop,
    pungutTarif,
    pungutTarifDescription,
    namaObjekPajak,
    lokasiId,
    namaLokasi,
    kodeGate,
    namaGate,
    idDevice,
    shift,
    alamat,
  ];
}
