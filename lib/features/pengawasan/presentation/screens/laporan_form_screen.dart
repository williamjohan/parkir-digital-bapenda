import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_form_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/presentation/widgets/laporan_section_card.dart';
import 'package:parkir_digital_bapenda/shared/loading/loading_overlay.dart';
import '../../../../../core/services/location/i_app_location_service.dart';
import '../../../../core/design_system/components/dropdown/pb_dropdown.dart';
import '../../../../core/design_system/components/pb_basic_bottom_sheet.dart';
import '../../domain/entities/jenis_pelanggaran/jenis_pelanggaran_entity.dart';
import '../cubit/pengawasan_cubit.dart';
import '../cubit/pengawasan_state.dart';

class LaporanFormScreen extends StatefulWidget {
  final IAppLocationService locationService;

  const LaporanFormScreen({super.key, required this.locationService});

  @override
  State<LaporanFormScreen> createState() => _LaporanFormScreenState();
}

class _LaporanFormScreenState extends State<LaporanFormScreen> {
  final _keteranganController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // 🔥 Key buat capture area foto + watermark jadi 1 gambar
  final GlobalKey _photoKey = GlobalKey();

  File? _photo;
  DateTime? _photoTakenAt;
  double? _latitude;
  double? _longitude;
  String? _placeName;
  String? _locationError;
  bool _isFetchingLocation = false;
  bool _isCapturing = false;

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PengawasanCubit>().loadJenisPelanggaran();
    });
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isFetchingLocation = true;
      _locationError = null;
    });

    try {
      final result = await widget.locationService.getCurrentLocation();

      setState(() {
        _latitude = double.tryParse(result.latitude);
        _longitude = double.tryParse(result.longitude);
        _placeName = result.address;
        _isFetchingLocation = false;
      });
    } catch (e) {
      setState(() {
        _locationError = e.toString();
        _isFetchingLocation = false;
      });
    }
  }

  Future<void> _pickPhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (!mounted) return;

    if (image != null) {
      setState(() {
        _photo = File(image.path);
        _photoTakenAt = DateTime.now();
      });
      await _fetchLocation(); // refresh lokasi saat foto diambil
    }
  }

  void _removePhoto() {
    setState(() {
      _photo = null;
      _photoTakenAt = null;
    });
    context.read<PengawasanCubit>().removeFoto();
  }

  /// 🔥 Capture Stack (foto + overlay lokasi/waktu) jadi 1 file PNG baru.
  Future<File?> _captureWatermarkedImage() async {
    try {
      final boundary =
          _photoKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 1.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final pngBytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/laporan_watermarked_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e) {
      debugPrint('Gagal capture watermark: $e');
      return null;
    }
  }

  Future<void> _submit() async {
    if (_photo == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Foto bukti wajib diambil")));
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi belum terdeteksi, coba lagi")),
      );
      return;
    }

    if (_isFetchingLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tunggu lokasi selesai terdeteksi")),
      );
      return;
    }

    setState(() => _isCapturing = true);
    await Future.delayed(const Duration(milliseconds: 300));
    final capturedFile = await _captureWatermarkedImage();

    if (!mounted) return;
    setState(() => _isCapturing = false);

    if (capturedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memproses foto, coba ambil ulang")),
      );
      return;
    }

    if (!mounted) return;
    context.read<PengawasanCubit>().setFoto(capturedFile);
    context.read<PengawasanCubit>().submit(_keteranganController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PengawasanCubit, PengawasanState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading || _isCapturing,
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
              scrolledUnderElevation: 0,
              shape: Border(
                bottom: BorderSide(color: AppColors.primary, width: 1.0),
              ),
              elevation: 0,
              foregroundColor: Colors.black,
              iconTheme: IconThemeData(color: AppColors.primary),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 🔥 SECTION FOTO — dipindah paling atas
                _buildPhotoSection(),
                const SizedBox(height: 16),

                BlocBuilder<PengawasanCubit, PengawasanState>(
                  builder: (context, state) {
                    JenisPelanggaranEntity? selected;

                    try {
                      selected = state.jenisPelanggaran.firstWhere(
                        (e) => e.id == state.request.jenisPel,
                      );
                    } catch (_) {
                      selected = null;
                    }

                    return LaporanSectionCard(
                      title: 'Jenis Pelanggaran',
                      icon: Icons.report_problem_outlined,
                      child: PbDropdown<JenisPelanggaranEntity>(
                        hintText: 'Pilih jenis pelanggaran',
                        value: selected,
                        itemLabel: (item) => item.nama,
                        onTap: () {
                          PbBasicBottomSheet.show(
                            context: context,
                            title: 'Pilih Jenis Pelanggaran',
                            child: SizedBox(
                              height: 350,
                              child: ListView.builder(
                                padding: EdgeInsets.only(top: 16),
                                shrinkWrap: true,
                                itemCount: state.jenisPelanggaran.length,
                                itemBuilder: (_, index) {
                                  final item = state.jenisPelanggaran[index];

                                  final isSelected =
                                      item.id == state.request.jenisPel;

                                  return GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.disabled,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.nama,
                                              style: AppTypography.caption
                                                  .copyWith(
                                                    color: isSelected
                                                        ? AppColors.primary
                                                        : AppColors.disabled,
                                                  ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            isSelected
                                                ? Icons
                                                      .radio_button_checked_outlined
                                                : Icons
                                                      .radio_button_off_outlined,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.disabled,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      context
                                          .read<PengawasanCubit>()
                                          .setJenisPelanggaran(item.id);

                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                LaporanSectionCard(
                  title: "Keterangan",
                  icon: Icons.notes_rounded,
                  child: TextFormField(
                    controller: _keteranganController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Jelaskan detail kejadian di sini...",
                      hintStyle: AppTypography.bodySmall.copyWith(
                        color: Colors.grey.shade400,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.error),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocConsumer<PengawasanCubit, PengawasanState>(
                listenWhen: (prev, curr) =>
                    prev.isSuccess != curr.isSuccess ||
                    prev.errorMessage != curr.errorMessage,
                listener: (context, state) {
                  if (state.isSuccess) {
                    FormResultDialog.showSuccess(
                      context,
                      title: "Laporan Berhasil",
                      description: "Laporan pelanggaran kamu sudah tersimpan",
                      onConfirm: () => Navigator.of(context).pop(true),
                    );
                    return;
                  }

                  if (state.errorMessage != null) {
                    FormResultDialog.showError(
                      context,
                      title: "Gagal",
                      description: state.errorMessage!,
                      onConfirm: () {
                        // tetap di screen ini biar user bisa coba lagi
                      },
                    );
                  }
                },
                builder: (context, state) {
                  return PbPrimaryButton(
                    text: "Kirim Laporan",
                    onPressed: (state.isLoading || _isCapturing)
                        ? null
                        : _submit,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔥 SECTION FOTO — style konsisten dengan ShiftFormScreen, estetik
  Widget _buildPhotoSection() {
    return LaporanSectionCard(
      title: "Foto Bukti Pelanggaran",
      icon: Icons.camera_alt_rounded,
      child: GestureDetector(
        onTap: _pickPhoto,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: RepaintBoundary(
            key: _photoKey,
            child: Container(
              width: double.infinity,
              height: 240,
              color: Colors.grey.shade100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_photo != null)
                    Image.file(_photo!, fit: BoxFit.cover)
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_rounded,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Ketuk untuk ambil foto bukti",
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),

                  // watermark info lokasi & waktu
                  if (_photo != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.0),
                              Colors.black.withValues(alpha: 0.75),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isFetchingLocation)
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Mendeteksi lokasi...",
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            else if (_locationError != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    size: 12,
                                    color: Colors.orangeAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _locationError!,
                                      style: AppTypography.caption.copyWith(
                                        color: Colors.orangeAccent,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              if (_placeName != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: const Icon(
                                        Icons.location_on_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        _placeName!,
                                        style: AppTypography.caption.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              if (_latitude != null && _longitude != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    "${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}",
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              if (_photoTakenAt != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    _formatStampTime(_photoTakenAt!),
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),

                  // tombol retake / hapus, pojok kanan atas
                  if (_photo != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _pickPhoto,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.refresh_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: _removePhoto,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatStampTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return "${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m";
  }
}
