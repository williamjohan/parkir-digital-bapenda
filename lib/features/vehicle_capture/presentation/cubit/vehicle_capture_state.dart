// lib/features/vehicle_capture/presentation/cubit/vehicle_capture_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/license_plate.dart';

enum CaptureStatus {
  initial,
  capturing,
  cameraReady,
  processing,
  success,
  error,
  standby,
}

class VehicleCaptureState extends Equatable {
  final CaptureStatus status;
  final LicensePlate? licensePlate;
  final String? errorMessage;
  final bool isFlashOn;
  final String? capturedImagePath;

  const VehicleCaptureState({
    this.status = CaptureStatus.initial,
    this.licensePlate,
    this.errorMessage,
    this.isFlashOn = false,
    this.capturedImagePath,
  });

  VehicleCaptureState copyWith({
    CaptureStatus? status,
    LicensePlate? licensePlate,
    String? errorMessage,
    bool? isFlashOn,
    String? capturedImagePath,
    bool clearImagePath = false,
  }) {
    return VehicleCaptureState(
      status: status ?? this.status,
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
    licensePlate,
    errorMessage,
    isFlashOn,
    capturedImagePath,
  ];
}
