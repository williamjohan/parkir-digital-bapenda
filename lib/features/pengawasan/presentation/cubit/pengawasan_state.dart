import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/domain/entities/jenis_pelanggaran/jenis_pelanggaran_entity.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/domain/entities/request_laporan_pengawasan_entity/request_laporan_pengawasan_entity.dart';

import '../../../../core/enums/app_enums.dart';

part 'pengawasan_state.freezed.dart';

// 1. TAMBAHKAN ENUM STATUS UNTUK TRIGGER DIALOG PENGATURAN DI UI
enum PengawasanStatus {
  initial,
  loading,
  success,
  failure,
  permissionDenied,
  gpsOff,
}

@freezed
class PengawasanState with _$PengawasanState {
  const PengawasanState._();

  const factory PengawasanState({
    // 🚀 2. TAMBAHKAN PROPERTI STATUS
    @Default(PengawasanStatus.initial) PengawasanStatus status,
    AppPermissionType? deniedPermissionType,
    @Default(RequestLaporanPengawasanEntity())
    RequestLaporanPengawasanEntity request,

    @Default(false) bool isLoading,
    @Default(false) bool isLoadingLaporan,
    @Default(false) bool isSuccess,
    String? errorMessage,

    File? rawPhoto,
    DateTime? photoTakenAt,
    double? latitude,
    double? longitude,
    String? placeName,
    String? locationError,
    @Default(false) bool isFetchingLocation,
    @Default(false) bool isCapturing,

    @Default('') String keteranganText,

    @Default([]) List<JenisPelanggaranEntity> jenisPelanggaran,
    @Default(<LaporanPengawasanEntity>[]) List<LaporanPengawasanEntity> laporan,
    @Default(<LaporanPengawasanEntity>[])
    List<LaporanPengawasanEntity> laporanFake,
  }) = _PengawasanState;

  bool get isLoading2 => isLoading;

  bool get canSubmit =>
      rawPhoto != null &&
      latitude != null &&
      longitude != null &&
      request.jenisPel != 0 &&
      keteranganText.trim().isNotEmpty &&
      !isFetchingLocation;
}
