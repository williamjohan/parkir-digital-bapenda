// lib/features/vehicle_capture/presentation/cubit/vehicle_capture_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/vehicle_category.dart';
import '../../domain/usecases/extract_license_plate_usecase.dart';
import 'vehicle_capture_state.dart';

@injectable
class VehicleCaptureCubit extends Cubit<VehicleCaptureState> {
  final ExtractLicensePlateUseCase extractLicensePlateUseCase;

  VehicleCaptureCubit(this.extractLicensePlateUseCase)
    : super(const VehicleCaptureState());

  /// Dipanggil saat jukir memilih motor/mobil di Home
  void selectVehicle(VehicleCategory category) {
    emit(
      state.copyWith(
        selectedCategory: category,
        status:
            CaptureStatus.cameraReady, // Langsung ubah status siap buka kamera
        errorMessage: null,
      ),
    );
  }

  /// Dipanggil untuk toggle Flashlight on/off
  void toggleFlash() {
    emit(state.copyWith(isFlashOn: !state.isFlashOn));
  }

  /// Dipanggil saat jukir ingin memfoto ulang
  void retakePhoto() {
    emit(
      state.copyWith(
        status: CaptureStatus.cameraReady,
        licensePlate: null,
        errorMessage: null,
      ),
    );
  }

  /// Dipanggil SETELAH jukir menjepret gambar dan gambar tersimpan di storage lokal
  Future<void> processCapturedImage(String imagePath) async {
    // 1. Matikan kamera sementara dan tampilkan indikator loading OCR
    emit(state.copyWith(status: CaptureStatus.processing, errorMessage: null));

    // 2. Eksekusi UseCase (OCR + Regex)
    final result = await extractLicensePlateUseCase.execute(imagePath);

    // 3. Tangani hasil
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CaptureStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (licensePlate) {
        emit(
          state.copyWith(
            status: CaptureStatus.success,
            licensePlate: licensePlate,
          ),
        );
      },
    );
  }
}
