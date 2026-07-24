import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/domain/entities/alat_digital_entity.dart';

import '../../../../../core/enums/app_enums.dart';

part 'absensi_state.freezed.dart';

// TAMBAHAN:  permissionDenied dan gpsOff agar UI tahu kapan harus memunculkan dialog Pengaturan
enum AbsensiStatus {
  initial,
  loading,
  success,
  failure,
  permissionDenied,
  gpsOff,
}

@freezed
class AbsensiState with _$AbsensiState {
  const AbsensiState._();

  const factory AbsensiState({
    @Default(AbsensiStatus.initial) AbsensiStatus status,
    @Default('') String errorMessage,
    AppPermissionType? deniedPermissionType,
    JenisPengawasan? jenis,
    String? nop, // 🆕
    ShiftPengawasan? shift,
    // --- STATE UNTUK UI FORM ---
    File? rawPhoto, // Foto asli sebelum di-watermark
    File? watermarkedPhoto, // Foto hasil watermark, siap dikirim
    DateTime? photoTakenAt,
    double? latitude,
    double? longitude,
    String? placeName,
    String? locationError,
    @Default(false) bool isFetchingLocation,
    @Default(false) bool isCapturing,

    // --- INPUT FORM ---
    @Default('') String motorText,
    @Default('') String mobilText,
    @Default([]) List<AlatDigitalEntity> allInstruments,
    @Default([]) List<int> selectedInstrumentIds,
    @Default(false) bool isLoadingInstruments,
  }) = _AbsensiState;

  List<AlatDigitalEntity> get filteredInstruments =>
      allInstruments.where((i) => i.jenis == jenis?.id).toList();
  bool get isLoading => status == AbsensiStatus.loading;

  int get totalMotor => int.tryParse(motorText) ?? 0;
  int get totalMobil => int.tryParse(mobilText) ?? 0;

  bool get canSubmit =>
      rawPhoto != null &&
      latitude != null &&
      longitude != null &&
      motorText.isNotEmpty &&
      mobilText.isNotEmpty &&
      !isFetchingLocation;
}
