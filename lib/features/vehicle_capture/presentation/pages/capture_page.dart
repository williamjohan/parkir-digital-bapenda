// lib/features/vehicle_capture/presentation/pages/capture_page.dart

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_keyboard_dismiss_wrapper.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart'; // Import Typography
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

class _CapturePageState extends State<CapturePage> with WidgetsBindingObserver {
  final TextEditingController _plateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<VehicleCaptureCubit>().initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _plateController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cubit = context.read<VehicleCaptureCubit>();
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      cubit.disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      cubit.initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VehicleCaptureCubit, VehicleCaptureState>(
      listener: (context, state) {
        if (state.status == CaptureStatus.success) {
          _plateController.text = state.licensePlate?.formattedNumber ?? '';
          PbStatusSnackbar.show(context, message: 'Plat berhasil dipindai!');
        } else if (state.status == CaptureStatus.error) {
          _plateController.clear();
          PbStatusSnackbar.show(
            context,
            message:
                state.errorMessage ??
                'Gagal mendeteksi plat, silakan ketik manual.',
            isError: true,
            duration: const Duration(seconds: 4),
          );
        } else if (state.status == CaptureStatus.cameraReady) {
          _plateController.clear();
        }
      },
      builder: (context, state) {
        final cubit = context.read<VehicleCaptureCubit>();

        // State flags yang bersih
        final isLoading =
            state.status == CaptureStatus.processing ||
            state.status == CaptureStatus.capturing;
        final isCameraReady = state.status == CaptureStatus.cameraReady;
        final hasCapturedImage = state.capturedImagePath != null;

        return PopScope(
          // Kunci navigasi back HANYA saat loading (AI sedang bekerja)
          canPop: !isLoading,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && isLoading) {
              PbStatusSnackbar.show(
                context,
                message: 'Harap tunggu, sedang memproses...',
              );
            }
          },
          child: PbKeyboardDismissWrapper(
            child: Scaffold(
              backgroundColor: Colors.black,
              // Menggunakan Stack di level Scaffold untuk menempatkan Overlay Premium di paling atas
              body: SafeArea(
                child: Stack(
                  children: [
                    // --- LAYER 1: KONTEN UTAMA APLIKASI ---
                    Column(
                      children: [
                        // AREA KAMERA / HASIL FOTO
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (hasCapturedImage)
                                Image.file(
                                  File(state.capturedImagePath!),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              else if (cubit.cameraController != null &&
                                  cubit.cameraController!.value.isInitialized)
                                SizedBox.expand(
                                  child: FittedBox(
                                    fit: BoxFit
                                        .cover, // Samakan perilakunya dengan Image statis di atas
                                    child: SizedBox(
                                      // Resolusi sensor kamera native biasanya orientasinya terbalik (Landscape)
                                      // Jadi kita tukar width menjadi height agar proporsinya tidak melar.
                                      width:
                                          cubit
                                              .cameraController!
                                              .value
                                              .previewSize
                                              ?.height ??
                                          1,
                                      height:
                                          cubit
                                              .cameraController!
                                              .value
                                              .previewSize
                                              ?.width ??
                                          1,
                                      child: CameraPreview(
                                        cubit.cameraController!,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),

                              // Kotak Panduan (Hanya muncul jika lensa terbuka)
                              if (!hasCapturedImage &&
                                  state.selectedCategory != null)
                                VehicleOverlayGuide(
                                  category: state.selectedCategory!,
                                ),

                              // Tombol Flashlight
                              if (!hasCapturedImage && isCameraReady)
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: IconButton(
                                    onPressed: () => cubit.toggleFlash(),
                                    icon: Icon(
                                      state.isFlashOn
                                          ? Icons.flash_on
                                          : Icons.flash_off,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),

                              // Tombol Back UI
                              Positioned(
                                top: 16,
                                left: 16,
                                child: IconButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => Navigator.of(context).pop(),
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

                        // AREA BAWAH: FORM & BUTTON
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Colors.white,
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PbTextField(
                                  controller: _plateController,
                                  // --- FIX DYNAMIC PLACEHOLDER ---
                                  hintText: hasCapturedImage
                                      ? 'Ketik manual (Contoh: L 1234 AB)'
                                      : 'Wajib foto kendaraan dulu',
                                  labelText: 'Nomor Plat Kendaraan',
                                  // ENHANCEMENT 2: Disabled jika belum ada foto, Enabled jika sudah ada foto
                                  enabled: hasCapturedImage && !isLoading,
                                  // Hapus loading di level TextField agar bersih
                                  isLoading: false,
                                ),
                                const SizedBox(height: 16),

                                // LOGIC TOMBOL ADAPTIF
                                if (hasCapturedImage)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: isLoading
                                              ? null
                                              : () => cubit.retakePhoto(),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text('Foto Ulang'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: PbPrimaryButton(
                                          text: 'Lanjut Bayar',
                                          // Hapus loading di level Button agar bersih
                                          isLoading: false,
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                                  if (_plateController.text
                                                      .trim()
                                                      .isEmpty) {
                                                    PbStatusSnackbar.show(
                                                      context,
                                                      message:
                                                          'Plat nomor tidak boleh kosong',
                                                      isError: true,
                                                    );
                                                    return;
                                                  }
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
                                  PbPrimaryButton(
                                    text: 'Ambil Foto Kendaraan',
                                    icon: Icons.camera_alt,
                                    // Hapus loading di level Button agar bersih
                                    isLoading: false,
                                    onPressed: isCameraReady
                                        ? () => cubit.captureAndProcessImage()
                                        : null,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // --- LAYER 2: ENHANCEMENT 1 - PREMIUM UNIFIED LOADING OVERLAY ---
                    if (isLoading)
                      Container(
                        // Latar belakang abu-abu transparan premium feel
                        color: Colors.black.withValues(alpha: 0.7),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Spinner Putih Besar di tengah
                              const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 5,
                              ),
                              const SizedBox(height: 24),
                              // Teks Peringatan/Edukasi Jukir ala premium app
                              Text(
                                'Harap tunggu...\nSedang memproses plat nomor.',
                                textAlign: TextAlign.center,
                                style: AppTypography.heading3.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Jangan keluar dari halaman ini.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
