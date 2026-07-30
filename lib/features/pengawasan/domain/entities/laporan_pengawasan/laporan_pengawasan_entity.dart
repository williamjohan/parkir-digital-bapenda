import 'package:equatable/equatable.dart';

class LaporanPengawasanEntity extends Equatable {
  final int idEvent;
  final String nip;
  final String opd;
  final String kdCamat;
  final String nmCamat;
  final String kdOp;
  final String nmOp;
  final int jenis;
  final int shift;
  final DateTime tglPengawasan;
  final int seq;
  final int jenisPel;
  final String ketPel;
  final DateTime insDate;
  final String insBy;
  final String? fotoPelaporan;

  const LaporanPengawasanEntity({
    required this.idEvent,
    required this.nip,
    required this.opd,
    required this.kdCamat,
    required this.nmCamat,
    required this.kdOp,
    required this.nmOp,
    required this.jenis,
    required this.shift,
    required this.tglPengawasan,
    required this.seq,
    required this.jenisPel,
    required this.ketPel,
    required this.insDate,
    required this.insBy,
    this.fotoPelaporan,
  });

  @override
  List<Object?> get props => [
    idEvent,
    nip,
    opd,
    kdCamat,
    nmCamat,
    kdOp,
    nmOp,
    jenis,
    shift,
    tglPengawasan,
    seq,
    jenisPel,
    ketPel,
    insDate,
    insBy,
    fotoPelaporan,
  ];
}
