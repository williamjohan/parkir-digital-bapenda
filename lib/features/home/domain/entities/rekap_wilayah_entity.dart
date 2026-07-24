import 'package:equatable/equatable.dart';

class RekapWilayahEntity extends Equatable {
  final String kodeOpd;
  final String namaOpd;
  final List<DetailRekapWilayahEntity> detailList;

  const RekapWilayahEntity({
    required this.kodeOpd,
    required this.namaOpd,
    required this.detailList,
  });

  @override
  List<Object?> get props => [kodeOpd, namaOpd, detailList];
}

class DetailRekapWilayahEntity extends Equatable {
  final String kdCamat;
  final String nmCamat;
  final int jmlObjekPajak;
  final int jmlTju;

  const DetailRekapWilayahEntity({
    required this.kdCamat,
    required this.nmCamat,
    required this.jmlObjekPajak,
    required this.jmlTju,
  });

  @override
  List<Object?> get props => [kdCamat, nmCamat, jmlObjekPajak, jmlTju];
}
