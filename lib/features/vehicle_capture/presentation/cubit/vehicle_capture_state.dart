// lib/features/vehicle_capture/presentation/cubit/vehicle_capture_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/license_plate.dart';
import '../../domain/entities/vehicle_category.dart';

enum CaptureStatus {
  initial,
  capturing,
  cameraReady,
  processing,
  success,
  error,
  navigatingToPayment,
  standby,
}

class VehicleCaptureState extends Equatable {
  final CaptureStatus status;
  final VehicleCategory? selectedCategory;
  final LicensePlate? licensePlate;
  final String? errorMessage;
  final bool isFlashOn;
  final String? capturedImagePath;
  final bool isFreeParking;

  const VehicleCaptureState({
    this.status = CaptureStatus.initial,
    this.selectedCategory,
    this.licensePlate,
    this.errorMessage,
    this.isFlashOn = false,
    this.capturedImagePath,
    this.isFreeParking = false, // Pessimistic Default (Cari Aman)
  });

  VehicleCaptureState copyWith({
    CaptureStatus? status,
    VehicleCategory? selectedCategory,
    LicensePlate? licensePlate,
    String? errorMessage,
    bool? isFlashOn,
    String? capturedImagePath,
    bool clearImagePath = false,
    bool? isFreeParking, // [PERBAIKAN 1]: Tambahkan di parameter
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
      isFreeParking:
          isFreeParking ?? this.isFreeParking, // [PERBAIKAN 2]: Update nilainya
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
    isFreeParking, // [PERBAIKAN 3]: Daftarkan ke Equatable agar UI bisa mendeteksi perubahan!
  ];
}
