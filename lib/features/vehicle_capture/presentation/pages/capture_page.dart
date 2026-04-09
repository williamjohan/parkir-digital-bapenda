import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_keyboard_dismiss_wrapper.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/design_system/components/pb_ticket_print_dialog.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/components/pb_text_field.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../parking_transaction/persentation/cubit/parking_transaction_cubit.dart';
import '../../../parking_transaction/persentation/cubit/parking_transaction_state.dart';
import '../../../parking_transaction/persentation/cubit/sync_cubit.dart';
import '../../../payment/presentation/pages/payment_page.dart';
import '../cubit/vehicle_capture_cubit.dart';
import '../cubit/vehicle_capture_state.dart';
import '../widgets/vehicle_overlay_guide.dart';

class CapturePage extends StatefulWidget {
  final String kategoriKendaraan;
  const CapturePage({super.key, required this.kategoriKendaraan});

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

    // 2. [PERBAIKAN]: Inisialisasi referensi
    _captureCubit = context.read<VehicleCaptureCubit>();
    _captureCubit.initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _plateController.dispose();

    if (!_isCameraManuallyDisposed) {
      _captureCubit.disposeCamera();
    }
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
        // Tambahkan delay kecil agar OS Android sempat release surface lama
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _captureCubit.initCamera();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParkingTransactionCubit, ParkingTransactionState>(
      listener: (context, parkingState) async {
        if (parkingState is ParkingTransactionFailure) {
          // Jika gagal simpan ke SQLite atau gagal kompres
          PbStatusSnackbar.show(
            context,
            message: parkingState.message,
            isError: true,
          );
          context
              .read<VehicleCaptureCubit>()
              .cancelNavigation(); // Batalkan loading
        } else if (parkingState is ParkingTransactionSaveSuccess) {
          final trx = parkingState.transaction;
          final profile = parkingState.jukirProfile;

          // [PERBAIKAN 2]: THE FREE PARKING RULE
          if (trx.status == 'PENDING_PAYMENT') {
            // --- KAWASAN BERBAYAR (Wajib masuk Kasir/QRIS) ---
            context.read<SyncCubit>().syncDataBackground();

            final args = PaymentPageArgs(
              idTransaksiLokal:
                  trx.idTransaksiLokal, // [PERBAIKAN]: Ambil dari koper trx
              platNomor: trx.platNomor ?? _plateController.text.trim(),
              kategoriKendaraan: widget.kategoriKendaraan,
            );

            // Pindah layar ke Kasir dan tunggu kembaliannya
            final isSuccess = await context.push<bool>(
              AppRoutes.payment,
              extra: args,
            );

            // Guard keamanan memori
            if (!context.mounted) return;
            if (isSuccess == true) {
              context.read<ParkingTransactionCubit>().updateStatusToPaid(
                trx.idTransaksiLokal,
              );
              _plateController.clear();
              context.read<VehicleCaptureCubit>().resetCapture();
            } else {
              _plateController.clear();
              context.read<VehicleCaptureCubit>().resetCapture();
              PbStatusSnackbar.show(
                context,
                message: 'Pembayaran ditunda. Data tersimpan di riwayat.',
              );
            }
          } else {
            // --- KAWASAN GRATIS (Langsung Lunas) ---
            final captureCubit = context.read<VehicleCaptureCubit>();
            captureCubit.cancelNavigation();
            context.read<SyncCubit>().syncDataBackground();
            final platAktif = _plateController.text.trim();
            final platFinal = platAktif.isNotEmpty
                ? platAktif
                : (trx.platNomor ?? '-');

            // Panggil Modal Berhasil
            PbShowDialog.show(
              context,
              title: 'Berhasil!',
              description: 'Parkir GRATIS dengan Kamera\n$platFinal tercatat.',
              onConfirm: () {
                // Tampilkan Modal Karcis Modular
                PbTicketPrintDialog.showFromLocalTransaction(
                  context: context,
                  localTx: trx,
                  profile: profile,
                  kategoriKendaraan: widget.kategoriKendaraan,
                  isQuickMode: false,
                  noKendaraan: platFinal,
                  tarifParkir: 0,
                  onClosed: () {
                    _plateController.clear();
                    captureCubit.resetCapture();
                  },
                );
              },
            );
          }
        }
      },
      // Child-nya adalah BlocConsumer bawaan VehicleCapture milik Anda
      child: BlocConsumer<VehicleCaptureCubit, VehicleCaptureState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) async {
          // --- 1. HANDLE OCR STATUS ---
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
          // --- 2. HANDLE LEMPARAN KE SANG OTAK (PARKING TRANSACTION) ---
          else if (state.status == CaptureStatus.navigatingToPayment) {
            FocusManager.instance.primaryFocus?.unfocus();

            final String namaKategori = state.selectedCategory?.name ?? 'Mobil';
            final String platNomor = _plateController.text.trim();
            final String imagePath = state.capturedImagePath!;
            context.read<ParkingTransactionCubit>().processNewTransaction(
              platNomor: platNomor,
              kategoriKendaraan: namaKategori,
              imagePath: imagePath,
              modePlat: 1,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<VehicleCaptureCubit>();

          // [TAMBAHAN KECIL]: state.status == CaptureStatus.navigatingToPayment
          // dimasukkan agar UI tetap menunjukkan layar Loading Premium saat
          // Sang Otak sedang bekerja mengompres foto.
          final isLoading =
              state.status == CaptureStatus.processing ||
              state.status == CaptureStatus.capturing ||
              state.status == CaptureStatus.navigatingToPayment;

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
              child: Scaffold(
                backgroundColor: Colors.black,
                body: SafeArea(
                  child: Stack(
                    children: [
                      // --- LAYER 1: KONTEN UTAMA APLIKASI ---
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

                                if (!hasCapturedImage &&
                                    state.selectedCategory != null)
                                  VehicleOverlayGuide(
                                    category: state.selectedCategory!,
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
                                            text: state.isFreeParking
                                                ? 'Simpan Data'
                                                : 'Lanjut Bayar',
                                            isLoading: false,
                                            onPressed: isLoading
                                                ? null
                                                : () {
                                                    // [PERBAIKAN 3]: Variabel args yang tidak terpakai sudah dihapus
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

                                                    // Perintahkan Jenderal untuk navigasi
                                                    context
                                                        .read<
                                                          VehicleCaptureCubit
                                                        >()
                                                        .proceedToPayment();
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

                      // --- LAYER 2: PREMIUM UNIFIED LOADING OVERLAY ---
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
                                  'Harap tunggu...\nSedang memproses plat nomor.',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.heading3.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // [PERBAIKAN 2]: Mengganti bodySmall menjadi caption agar sesuai kamus Typography
                                Text(
                                  'Jangan keluar dari halaman ini.',
                                  style: AppTypography.caption.copyWith(
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
      ),
    );
  }
}
