// lib/features/vehicle_capture/presentation/pages/capture_page.dart

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/components/pb_text_field.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../cubit/vehicle_capture_cubit.dart';
import '../cubit/vehicle_capture_state.dart';
import '../widgets/vehicle_overlay_guide.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

// with WidgetsBindingObserver WAJIB untuk mendeteksi aplikasi masuk ke background
class _CapturePageState extends State<CapturePage> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  final TextEditingController _plateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Daftarkan observer
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Hapus observer
    _cameraController?.dispose(); // Bebaskan memory kamera
    _plateController.dispose();
    super.dispose();
  }

  // Mitigasi Overheat: Jika app diminimize, matikan kamera. Jika dibuka lagi, nyalakan.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized)
      return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      cameraController.dispose();
      _isCameraInitialized = false;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      // Cari kamera belakang
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();
      // Mengaktifkan Autofocus agar jukir tidak perlu tap manual
      await _cameraController!.setFocusMode(FocusMode.auto);

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted)
        PbStatusSnackbar.show(
          context,
          message: 'Gagal menginisialisasi kamera',
          isError: true,
        );
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;
    if (_cameraController!.value.isTakingPicture) return;

    try {
      final image = await _cameraController!.takePicture();
      // Freeze Frame: Matikan stream agar menghemat baterai saat ML Kit bekerja
      await _cameraController!.pausePreview();

      if (mounted) {
        // Panggil UseCase via Cubit
        context.read<VehicleCaptureCubit>().processCapturedImage(image.path);
      }
    } catch (e) {
      if (mounted)
        PbStatusSnackbar.show(
          context,
          message: 'Gagal memotret gambar',
          isError: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VehicleCaptureCubit, VehicleCaptureState>(
      listener: (context, state) async {
        // Sinkronisasi Flashlight dengan Hardware
        if (_cameraController != null &&
            _cameraController!.value.isInitialized) {
          await _cameraController!.setFlashMode(
            state.isFlashOn ? FlashMode.torch : FlashMode.off,
          );
        }

        // Jika berhasil, isi textfield otomatis
        if (state.status == CaptureStatus.success) {
          _plateController.text = state.licensePlate?.formattedNumber ?? '';
          PbStatusSnackbar.show(context, message: 'Plat berhasil dipindai!');
        }
        // Jika error, kembalikan stream kamera (Un-freeze)
        else if (state.status == CaptureStatus.error) {
          _plateController.clear();
          await _cameraController?.resumePreview();
          PbStatusSnackbar.show(
            context,
            message: state.errorMessage ?? 'Gagal',
            isError: true,
          );
        }
        // Jika user minta Retake, kembalikan stream kamera
        else if (state.status == CaptureStatus.cameraReady) {
          _plateController.clear();
          await _cameraController?.resumePreview();
        }
      },
      builder: (context, state) {
        final isLoading = state.status == CaptureStatus.processing;
        final isSuccess = state.status == CaptureStatus.success;

        return Scaffold(
          backgroundColor: Colors.black, // Tema gelap lebih hemat baterai
          body: SafeArea(
            child: Column(
              children: [
                // AREA 3/4: KAMERA (Flex 3)
                Expanded(
                  // flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Camera Preview
                      if (_isCameraInitialized && _cameraController != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(24),
                          ),
                          child: CameraPreview(_cameraController!),
                        )
                      else
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),

                      // Bounding Box Overlay (Hanya muncul jika belum success)
                      if (!isSuccess && state.selectedCategory != null)
                        VehicleOverlayGuide(category: state.selectedCategory!),

                      // Tombol Flashlight di pojok kanan atas
                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          onPressed: () =>
                              context.read<VehicleCaptureCubit>().toggleFlash(),
                          icon: Icon(
                            state.isFlashOn ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),

                      // Tombol Back di pojok kiri atas
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // AREA 1/4: FORM & BUTTON (Flex 1)
                // AREA BAWAH: FORM & BUTTON (Otomatis menyesuaikan tinggi konten)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // Tambahkan sedikit shadow pemisah antara kamera dan panel
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Penting: Agar Column setinggi kontennya saja
                      children: [
                        // Menggunakan PB TextField buatan kita
                        PbTextField(
                          controller: _plateController,
                          hintText: 'Contoh: L 1234 AB',
                          labelText: 'Nomor Plat Kendaraan',
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 16),

                        // Logic Tombol Dinamis
                        if (isSuccess)
                          Row(
                            children: [
                              // Tombol Retake (Kiri)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => context
                                      .read<VehicleCaptureCubit>()
                                      .retakePhoto(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Foto Ulang'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Tombol Submit Lanjut ke QRIS (Kanan)
                              Expanded(
                                child: PbPrimaryButton(
                                  text: 'Lanjut Bayar',
                                  onPressed: () {
                                    PbStatusSnackbar.show(
                                      context,
                                      message:
                                          'Lanjut ke QRIS dengan plat: ${_plateController.text}',
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        else
                          // Tombol Capture Default
                          PbPrimaryButton(
                            text: 'Pindai Plat Nomor',
                            icon: Icons.camera_alt,
                            isLoading: isLoading,
                            onPressed: _isCameraInitialized
                                ? _captureImage
                                : null,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
