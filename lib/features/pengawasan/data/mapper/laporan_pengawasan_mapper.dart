import 'dart:convert';

import '../../domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import '../models/laporan_pengawasan/laporan_pengawasan_model.dart';

extension LaporanPengawasanMapper on LaporanPengawasanModel {
  LaporanPengawasanEntity toEntity() {
    return LaporanPengawasanEntity(
      idEvent: idEvent,
      op: op,
      nip: nip,
      tglRoster: tglRoster,
      jadwalMasuk: jadwalMasuk,
      jenisPel: jenisPel,
      ketPel: ketPel,
      insDate: insDate,
      insBy: insBy,
      seq: seq,
      fotoPelaporan: fotoPelaporan == null || fotoPelaporan!.isEmpty
          ? null
          : base64Decode(fotoPelaporan!),
    );
  }
}
