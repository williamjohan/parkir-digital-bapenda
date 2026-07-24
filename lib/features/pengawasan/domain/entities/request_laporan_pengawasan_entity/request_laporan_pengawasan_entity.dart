import 'dart:io';

import 'package:equatable/equatable.dart';

class RequestLaporanPengawasanEntity extends Equatable {
  final int jenisPel;
  final String ketPel;
  final String nomorObjek;
  final int shift;
  final int jenis;
  final File? buktiFoto;

  const RequestLaporanPengawasanEntity({
    this.jenisPel = 0,
    this.ketPel = '',
    this.nomorObjek = '',
    this.shift = 0,
    this.jenis = 0,
    this.buktiFoto,
  });

  RequestLaporanPengawasanEntity copyWith({
    int? jenisPel,
    String? ketPel,
    String? nomorObjek,
    int? shift,
    int? jenis,
    File? buktiFoto,
  }) {
    return RequestLaporanPengawasanEntity(
      jenisPel: jenisPel ?? this.jenisPel,
      ketPel: ketPel ?? this.ketPel,
      nomorObjek: nomorObjek ?? this.nomorObjek,
      shift: shift ?? this.shift,
      jenis: jenis ?? this.jenis,
      buktiFoto: buktiFoto ?? this.buktiFoto,
    );
  }

  @override
  List<Object?> get props => [
    jenisPel,
    ketPel,
    nomorObjek,
    shift,
    jenis,
    buktiFoto,
  ];
}
