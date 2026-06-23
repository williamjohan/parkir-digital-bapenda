import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_realisasi_op_entity.freezed.dart';

@freezed
class RealisasiBulanEntity with _$RealisasiBulanEntity {
  const factory RealisasiBulanEntity({
    required String namaBulan, // Contoh: "Januari"
    required String tanggalSspd, // Contoh: "SSPD 04 Feb 2025"
    required double nominal, // Contoh: 860000
  }) = _RealisasiBulanEntity;
}

@freezed
class RealisasiTahunEntity with _$RealisasiTahunEntity {
  const factory RealisasiTahunEntity({
    required int tahun,
    required double totalRealisasi,
    @Default([]) List<RealisasiBulanEntity> daftarBulan,
  }) = _RealisasiTahunEntity;
}

// Enum untuk filter jenis pembayaran
enum JenisRealisasi { semua, digital, nonDigital }
