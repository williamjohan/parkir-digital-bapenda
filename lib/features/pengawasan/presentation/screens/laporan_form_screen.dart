import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_show_dialog.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/presentation/widgets/keterangan_section_card.dart';
import 'package:parkir_digital_bapenda/shared/loading/loading_overlay.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/design_system/components/pb_permission_dialog.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/watermark_utils.dart';
import '../cubit/pengawasan_cubit.dart';
import '../cubit/pengawasan_state.dart';
import '../widgets/jenis_pelanggaran_section.dart';
import '../widgets/photo_section_card.dart';

class LaporanFormScreen extends StatefulWidget {
  final File? recoveredPhoto;
  const LaporanFormScreen({super.key, this.recoveredPhoto});
  @override
  State<LaporanFormScreen> createState() => _LaporanFormScreenState();
}

class _LaporanFormScreenState extends State<LaporanFormScreen> {
  final _keteranganController = TextEditingController();
  final GlobalKey _photoKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PengawasanCubit>().initPage(
        recoveredPhoto: widget.recoveredPhoto,
      );
    });
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _submitLaporan() async {
    final cubit = context.read<PengawasanCubit>();
    final state = cubit.state;

    // Pre-validation di sisi UI agar tidak buang-buang waktu memproses watermark jika data kosong
    if (state.rawPhoto == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Foto bukti wajib diambil")));
      return;
    }
    if (state.latitude == null || state.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi belum terdeteksi, coba lagi")),
      );
      return;
    }
    if (state.isFetchingLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tunggu lokasi selesai terdeteksi")),
      );
      return;
    }

    // 1. Jalankan proses pembuatan watermark gambar
    cubit.setCapturing(true);
    await Future.delayed(const Duration(milliseconds: 300));
    final capturedFile = await PhotoUtils.setWatermarkImage(_photoKey);
    cubit.setCapturing(false);

    if (capturedFile == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal memproses foto, coba ambil ulang"),
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    // 2. Set foto hasil watermark ke request di Cubit
    cubit.setWatermarkedPhoto(capturedFile);

    // 3. Jalankan submit hanya dengan melemparkan teks keterangan
    cubit.submit(_keteranganController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PengawasanCubit, PengawasanState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.isSuccess != curr.isSuccess ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.isSuccess) {
          PbShowDialog.show(
            context,
            title: "Laporan Berhasil",
            description: "Laporan pelanggaran kamu sudah tersimpan",
            icon: Icons.check_circle_rounded,
            iconColor: AppColors.success,
            buttonText: "OK",
            onConfirm: () => Navigator.of(context).pop(true),
          );
        } else if (state.status == PengawasanStatus.permissionDenied) {
          PbPermissionDialog.show(
            context,
            type: state.deniedPermissionType ?? AppPermissionType.camera,
            status: AppPermissionStatus.permanentlyDenied,
            onActionPressed: () =>
                context.read<PengawasanCubit>().openAppSettings(),
          );
        } else if (state.status == PengawasanStatus.gpsOff) {
          PbPermissionDialog.show(
            context,
            type: AppPermissionType.locationService,
            status: AppPermissionStatus.permanentlyDenied,
            onActionPressed: () =>
                context.read<PengawasanCubit>().openLocationSettings(),
          );
        } else if (state.status == PengawasanStatus.failure &&
            state.errorMessage != null) {
          PbShowDialog.show(
            context,
            title: "Gagal",
            description: state.errorMessage!,
            buttonText: "Tutup",
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading || state.isCapturing,
          child: Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              title: Text(
                'Buat Laporan',
                style: AppTypography.heading5.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppColors.surface,
              elevation: 0,
            ),
            body: Skeletonizer(
              enabled: state.isLoadingJenisPelanggaran,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Seksi Foto Bukti
                  PhotoSectionCard(
                    photoKey: _photoKey,
                    photo: state.rawPhoto,
                    photoTakenAt: state.photoTakenAt,
                    isFetchingLocation: state.isFetchingLocation,
                    locationError: state.locationError,
                    placeName: state.placeName,
                    latitude: state.latitude,
                    longitude: state.longitude,
                    onPickPhoto: () =>
                        context.read<PengawasanCubit>().pickAndSetPhoto(),
                    onRemovePhoto: () =>
                        context.read<PengawasanCubit>().removePhoto(),
                  ),
                  const SizedBox(height: 16),

                  // 2. Seksi Jenis Pelanggaran (Sekarang bersih menggunakan widget baru!)
                  JenisPelanggaranSection(
                    jenisPelanggaranList: state.jenisPelanggaran,
                    selectedJenisPelId: state.request.jenisPel,
                    onJenisPelanggaranSelected: (id) {
                      context.read<PengawasanCubit>().setJenisPelanggaran(id);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Seksi Keterangan
                  KeteranganSectionCard(
                    keteranganController: _keteranganController,
                    onChanged: context.read<PengawasanCubit>().setKeterangan,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              // Gunakan ValueListenableBuilder untuk mendengarkan ketikan pada controller
              child: PbPrimaryButton(
                text: "Kirim Laporan",
                isDisabled: !state.canSubmit,
                onPressed: (state.isLoading || state.isCapturing)
                    ? null
                    : _submitLaporan,
              ),
            ),
          ),
        );
      },
    );
  }
}
