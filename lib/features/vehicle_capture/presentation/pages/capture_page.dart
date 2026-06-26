import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_keyboard_dismiss_wrapper.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/components/pb_text_field.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../cubit/vehicle_capture_cubit.dart';
import '../cubit/vehicle_capture_state.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key}); // 🚀 SUDAH BERSIH DARI PARAMETER BISNIS!

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> with WidgetsBindingObserver {
  bool _isCameraManuallyDisposed = false;
  final TextEditingController _plateController = TextEditingController();
  late VehicleCaptureCubit _captureCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _captureCubit = context.read<VehicleCaptureCubit>();
    _captureCubit.initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _plateController.dispose();
    if (!_isCameraManuallyDisposed) _captureCubit.disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _isCameraManuallyDisposed = true;
      _captureCubit.disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      if (_isCameraManuallyDisposed) {
        _isCameraManuallyDisposed = false;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) _captureCubit.initCamera();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VehicleCaptureCubit, VehicleCaptureState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
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

        final isLoading =
            state.status == CaptureStatus.processing ||
            state.status == CaptureStatus.capturing;
        final isCameraReady = state.status == CaptureStatus.cameraReady;
        final hasCapturedImage = state.capturedImagePath != null;

        return PopScope(
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
            child: SafeArea(
              bottom: true,
              top: false,
              child: Scaffold(
                backgroundColor: Colors.black,
                body: SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        children: [
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
                                      fit: BoxFit.cover,
                                      child: SizedBox(
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
                                    hintText: hasCapturedImage
                                        ? 'Ketik manual (Contoh: L 1234 AB)'
                                        : 'Wajib foto kendaraan dulu',
                                    labelText: 'Nomor Plat Kendaraan',
                                    enabled: hasCapturedImage && !isLoading,
                                    isLoading: false,
                                  ),
                                  const SizedBox(height: 16),

                                  if (hasCapturedImage)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: isLoading
                                                ? null
                                                : () => cubit.retakePhoto(),
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                            text:
                                                'Gunakan Plat Ini', // 🚀 NAMA TOMBOL DIUBAH
                                            isLoading: false,
                                            onPressed: isLoading
                                                ? null
                                                : () {
                                                    final plat =
                                                        _plateController.text
                                                            .trim();
                                                    if (plat.isEmpty) {
                                                      PbStatusSnackbar.show(
                                                        context,
                                                        message:
                                                            'Plat nomor tidak boleh kosong',
                                                        isError: true,
                                                      );
                                                      return;
                                                    }
                                                    Navigator.pop(context, {
                                                      'platNomor': plat,
                                                      'imagePath': state
                                                          .capturedImagePath,
                                                    });
                                                  },
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    PbPrimaryButton(
                                      text: 'Ambil Foto Kendaraan',
                                      iconLeft: Icons.camera_alt,
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

                      if (isLoading)
                        Container(
                          color: Colors.black.withValues(alpha: 0.7),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 5,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Harap tunggu...\nSedang membaca plat nomor.',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.heading3.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
          ),
        );
      },
    );
  }
}
