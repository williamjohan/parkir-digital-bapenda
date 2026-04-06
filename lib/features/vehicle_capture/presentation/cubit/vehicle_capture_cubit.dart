import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/image/i_image_service.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/entities/vehicle_category.dart';
import '../../domain/usecases/extract_license_plate_usecase.dart';
import 'vehicle_capture_state.dart';

@injectable
class VehicleCaptureCubit extends Cubit<VehicleCaptureState> {
  final ExtractLicensePlateUseCase _extractLicensePlateUseCase;
  final IImageService _imageService;
  final ISecureStorageManager _secureStorage;

  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;
  Future<void>? _initializeControllerFuture;

  VehicleCaptureCubit(
    this._extractLicensePlateUseCase,
    this._imageService,
    this._secureStorage,
  ) : super(const VehicleCaptureState()) {
    // Body dari constructor dijalankan setelah super() selesai
    _loadTarifConfig();
  }

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
    } catch (_) {}
  }

  /// Dipanggil saat jukir ingin memfoto ulang
  Future<void> retakePhoto() async {
    // 1. Bersihkan sampah cache gambar lama
    if (state.capturedImagePath != null &&
        state.capturedImagePath!.isNotEmpty) {
      await _imageService.deleteImage(state.capturedImagePath!);
    }

    // 2. Kembalikan stream lensa kamera
    try {
      await _cameraController?.resumePreview();
    } catch (_) {}

    // 3. Reset state ke awal (Hapus gambar, kosongkan plat/error)
    _safeEmit(
      state.copyWith(
        status: CaptureStatus.cameraReady,
        clearImagePath: true,
        errorMessage: null,
        // licensePlate tidak di-clear paksa di sini, tapi akan tertimpa saat OCR baru sukses
      ),
    );
  }

  /// Dipanggil SETELAH jukir menjepret gambar dan gambar tersimpan di storage lokal
  Future<void> captureAndProcessImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (_cameraController!.value.isTakingPicture) return;

    _safeEmit(state.copyWith(status: CaptureStatus.capturing));

    try {
      // 1. Jepret Gambar
      final image = await _cameraController!.takePicture();
      final imagePath = image.path;

      // 2. Pause Stream Lensa (Hemat Baterai & Fix UI Statis)
      await _cameraController!.pausePreview();

      // 3. Update State (Menampilkan gambar statis + status loading ML Kit)
      _safeEmit(
        state.copyWith(
          status: CaptureStatus.processing,
          capturedImagePath: imagePath,
        ),
      );

      // 4. Eksekusi ML Kit OCR
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

  /// Inisialisasi kamera, dipanggil saat masuk ke halaman Capture
  Future<void> initCamera() async {
    // 1. [SAFETY FIX]: Amankan controller lama dan putuskan dari UI
    final oldController = _cameraController;
    _cameraController = null;

    // 2. Emit status initial agar UI me-remove widget CameraPreview dari layar.
    // Ini krusial agar OS Android melepaskan "Surface/Pipa" kamera.
    emit(state.copyWith(status: CaptureStatus.initial));

    // 3. Bunuh controller lama secara fisik di level hardware
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

      // 4. Inisiasi baru dengan pattern Cek Reklame
      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _cameraController = controller;

      // Inisialisasi dan simpan di Future
      _initializeControllerFuture = controller.initialize();
      await _initializeControllerFuture;

      // Guard jika Cubit sudah terlanjur ditutup saat proses await
      if (isClosed) return;

      // 5. Safe Hardware Config (Granular Try-Catch)
      try {
        await controller.setFocusMode(FocusMode.auto);
      } catch (_) {}

      try {
        await controller.setFlashMode(
          state.isFlashOn ? FlashMode.torch : FlashMode.off,
        );
      } catch (_) {}

      // Sukses! Lempar ke UI
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

  /// Dipanggil saat keluar dari halaman Capture untuk membersihkan resource kamera
  Future<void> disposeCamera() async {
    final oldController = _cameraController;
    _cameraController =
        null; // Putuskan reference agar UI langsung berhenti render

    try {
      // Coba hancurkan kamera secara normal
      // Jika kamera sedang inisialisasi, TUNGGU sampai selesai baru dibunuh
      if (_initializeControllerFuture != null) {
        await _initializeControllerFuture;
      }
      await oldController?.dispose();
    } catch (e) {}
  }

  @override
  Future<void> close() {
    disposeCamera();
    return super.close();
  }

  Future<void> resetCapture() async {
    // 1. Bangunkan lensa kamera dari tidur (pause) setelah pembayaran sukses!
    try {
      await _cameraController?.resumePreview();
    } catch (_) {}

    // [PERBAIKAN]: Gunakan _safeEmit agar terhindar dari emit saat Cubit mati
    _safeEmit(
      VehicleCaptureState(
        status: CaptureStatus.cameraReady,
        selectedCategory: state.selectedCategory,
      ),
    );
  }

  /// Dipanggil saat tombol "Lanjut Bayar" diklik (Memicu BlocListener)
  void proceedToPayment() {
    _safeEmit(state.copyWith(status: CaptureStatus.navigatingToPayment));
  }

  /// Dipanggil saat Jukir membatalkan pembayaran (Menekan tombol Back HP di layar QRIS)
  void cancelNavigation() {
    // Kembalikan status ke 'success' karena Jukir sudah punya foto dan plat yang valid
    // UI akan kembali memunculkan foto kendaraan yang tadi tanpa meresetnya.
    _safeEmit(state.copyWith(status: CaptureStatus.standby));
  }

  void _safeEmit(VehicleCaptureState newState) {
    if (!isClosed) {
      emit(newState);
    }
  }

  Future<void> _loadTarifConfig() async {
    final profile = await _secureStorage.getJukirProfile();
    if (profile != null) {
      final tarif = profile['pungutTarif'];
      final isFree = (tarif == 1 || tarif == '1');

      // Pancarkan State ke UI!
      emit(state.copyWith(isFreeParking: isFree));
    }
  }
}
