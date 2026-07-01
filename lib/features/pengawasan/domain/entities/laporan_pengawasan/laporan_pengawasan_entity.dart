import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'laporan_pengawasan_entity.freezed.dart';

@freezed
class LaporanPengawasanEntity with _$LaporanPengawasanEntity {
  const factory LaporanPengawasanEntity({
    required int idEvent,
    required String op,
    required String nip,
    required DateTime tglRoster,
    required DateTime jadwalMasuk,
    required int jenisPel,
    required String ketPel,
    required DateTime insDate,
    required String insBy,
    required int seq,
    Uint8List? fotoPelaporan,
  }) = _LaporanPengawasanEntity;
}
