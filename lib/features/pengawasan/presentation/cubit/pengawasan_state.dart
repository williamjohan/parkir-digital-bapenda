import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/jenis_pelanggaran/jenis_pelanggaran_entity.dart';
import '../../domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import '../../domain/entities/request_laporan_pengawasan_entity/request_laporan_pengawasan_entity.dart';

part 'pengawasan_state.freezed.dart';

@freezed
class PengawasanState with _$PengawasanState {
  const factory PengawasanState({
    @Default(RequestLaporanPengawasanEntity())
    RequestLaporanPengawasanEntity request,

    @Default(false) bool isLoading,
    @Default(false) bool isLoadingLaporan,
    @Default(false) bool isSuccess,
    String? errorMessage,

    // --- TAMBAHAN STATE UNTUK UI FORM ---
    File? rawPhoto, // Foto asli sebelum di-watermark
    DateTime? photoTakenAt,
    double? latitude,
    double? longitude,
    String? placeName,
    String? locationError,
    @Default(false) bool isFetchingLocation,
    @Default(false) bool isCapturing,

    // ------------------------------------
    @Default([]) List<JenisPelanggaranEntity> jenisPelanggaran,
    @Default(<LaporanPengawasanEntity>[]) List<LaporanPengawasanEntity> laporan,
    @Default(<LaporanPengawasanEntity>[])
    List<LaporanPengawasanEntity> laporanFake,
  }) = _PengawasanState;
}
