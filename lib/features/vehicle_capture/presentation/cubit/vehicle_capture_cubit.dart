import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/image/i_image_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/extract_license_plate_usecase.dart';
import 'vehicle_capture_state.dart';

@injectable
class VehicleCaptureCubit extends Cubit<VehicleCaptureState> {
  final ExtractLicensePlateUseCase _extractLicensePlateUseCase;
  final IImageService _imageService;

  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;
  Future<void>? _initializeControllerFuture;

  VehicleCaptureCubit(this._extractLicensePlateUseCase, this._imageService)
    : super(const VehicleCaptureState());

  Future<void> toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    final newFlashState = !state.isFlashOn;
    try {
      await _cameraController!.setFlashMode(
        newFlashState ? FlashMode.torch : FlashMode.off,
      );
      _safeEmit(state.copyWith(isFlashOn: newFlashState));
    } catch (e) {
      AppLogger.error('Gagal mengubah status senter/flash: $e');
    }
  }

  Future<void> retakePhoto() async {
    if (state.capturedImagePath != null &&
        state.capturedImagePath!.isNotEmpty) {
      await _imageService.deleteImage(state.capturedImagePath!);
    }
    try {
      await _cameraController?.resumePreview();
    } catch (_) {}

    _safeEmit(
      state.copyWith(
        status: CaptureStatus.cameraReady,
        clearImagePath: true,
        errorMessage: null,
      ),
    );
  }

  Future<void> captureAndProcessImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (_cameraController!.value.isTakingPicture) return;

    _safeEmit(state.copyWith(status: CaptureStatus.capturing));

    try {
      final image = await _cameraController!.takePicture();
      final imagePath = image.path;
      await _cameraController!.pausePreview();

      _safeEmit(
        state.copyWith(
          status: CaptureStatus.processing,
          capturedImagePath: imagePath,
        ),
      );

      final result = await _extractLicensePlateUseCase.execute(imagePath);

      result.fold(
        (failure) {
          _safeEmit(
            state.copyWith(
              status: CaptureStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (licensePlate) {
          _safeEmit(
            state.copyWith(
              status: CaptureStatus.success,
              licensePlate: licensePlate,
            ),
          );
        },
      );
    } catch (e) {
      _safeEmit(
        state.copyWith(
          status: CaptureStatus.error,
          errorMessage: 'Gagal memproses gambar.',
        ),
      );
    }
  }

  Future<void> initCamera() async {
    final oldController = _cameraController;
    _cameraController = null;
    emit(state.copyWith(status: CaptureStatus.initial));

    if (oldController != null) {
      await oldController.dispose();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception("Kamera tidak ditemukan");

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      _cameraController = controller;
      _initializeControllerFuture = controller.initialize();
      await _initializeControllerFuture;

      if (isClosed) return;

      try {
        await controller.setFocusMode(FocusMode.auto);
      } catch (_) {}
      try {
        await controller.setFlashMode(
          state.isFlashOn ? FlashMode.torch : FlashMode.off,
        );
      } catch (_) {}

      _safeEmit(state.copyWith(status: CaptureStatus.cameraReady));
    } catch (e) {
      _safeEmit(
        state.copyWith(
          status: CaptureStatus.error,
          errorMessage: 'Gagal menginisialisasi kamera: $e',
        ),
      );
    }
  }

  Future<void> disposeCamera() async {
    final oldController = _cameraController;
    _cameraController = null;

    try {
      if (_initializeControllerFuture != null) {
        await _initializeControllerFuture;
      }

      await oldController?.dispose();
    } catch (e) {
      AppLogger.error('Gagal melakukan dispose pada CameraController: $e');
    }
  }

  @override
  Future<void> close() {
    disposeCamera();
    return super.close();
  }

  void _safeEmit(VehicleCaptureState newState) {
    if (!isClosed) emit(newState);
  }
}
