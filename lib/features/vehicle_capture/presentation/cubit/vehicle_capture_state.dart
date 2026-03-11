// lib/features/vehicle_capture/presentation/cubit/vehicle_capture_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/license_plate.dart';
import '../../domain/entities/vehicle_category.dart';

enum CaptureStatus {
  initial, // Di halaman Home (Pilih Kendaraan)
  capturing, // Proses kamera menyala, menunggu jepret
  cameraReady, // Kamera menyala, siap jepret
  processing, // Loading OCR ML Kit bekerja
  success, // OCR Berhasil, TextField muncul
  error, // Gagal baca plat / Error sistem
  navigatingToPayment,
}

class VehicleCaptureState extends Equatable {
  final CaptureStatus status;
  final VehicleCategory? selectedCategory;
  final LicensePlate? licensePlate;
  final String? errorMessage;
  final bool isFlashOn;
  final String? capturedImagePath;

  const VehicleCaptureState({
    this.status = CaptureStatus.initial,
    this.selectedCategory,
    this.licensePlate,
    this.errorMessage,
    this.isFlashOn = false,
    this.capturedImagePath,
  });

  VehicleCaptureState copyWith({
    CaptureStatus? status,
    VehicleCategory? selectedCategory,
    LicensePlate? licensePlate,
    String? errorMessage,
    bool? isFlashOn,
    String? capturedImagePath,
    bool clearImagePath = false,
  }) {
    return VehicleCaptureState(
      status: status ?? this.status,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      licensePlate: licensePlate ?? this.licensePlate,
      errorMessage: errorMessage ?? this.errorMessage,
      capturedImagePath: clearImagePath
          ? null
          : (capturedImagePath ?? this.capturedImagePath),
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedCategory,
    licensePlate,
    errorMessage,
    isFlashOn,
    capturedImagePath,
  ];
}
