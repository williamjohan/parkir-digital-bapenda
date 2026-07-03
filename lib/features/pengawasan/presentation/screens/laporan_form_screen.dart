import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/presentation/widgets/laporan_section_card.dart';
import '../../../../core/design_system/components/dropdown/pb_dropdown.dart';
import '../../../../core/design_system/components/pb_basic_bottom_sheet.dart';
import '../../domain/entities/jenis_pelanggaran/jenis_pelanggaran_entity.dart';
import '../cubit/pengawasan_cubit.dart';
import '../cubit/pengawasan_state.dart';
import '../widgets/laporan_photo_picker.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_show_dialog.dart';

class LaporanFormScreen extends StatefulWidget {
  // final void Function(LaporanFormResult result) onSubmit;

  const LaporanFormScreen({super.key});

  @override
  State<LaporanFormScreen> createState() => _LaporanFormScreenState();
}

class _LaporanFormScreenState extends State<LaporanFormScreen> {
  final _keteranganController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (!mounted) return;

    if (image != null) {
      context.read<PengawasanCubit>().setFoto(File(image.path));
    }
  }

  void _removePhoto() {
    context.read<PengawasanCubit>().removeFoto();
  }

  void _submit() {
    context.read<PengawasanCubit>().submit(_keteranganController.text);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PengawasanCubit>().loadJenisPelanggaran();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        shape: Border(bottom: BorderSide(color: AppColors.primary, width: 1.0)),
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                          // separatorBuilder: (_, __) => const Divider(height: 1),
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
                                        style: AppTypography.caption.copyWith(
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
                                          ? Icons.radio_button_checked_outlined
                                          : Icons.radio_button_off_outlined,
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

                            // return ListTile(
                            //   contentPadding: EdgeInsets.zero,
                            //   title: Text(item.nama),
                            //   trailing: isSelected
                            //       ? const Icon(
                            //           Icons.check_circle,
                            //           color: AppColors.primary,
                            //         )
                            //       : null,
                            //   onTap: () {
                            //     context
                            //         .read<PengawasanCubit>()
                            //         .setJenisPelanggaran(item.id);

                            //     Navigator.pop(context);
                            //   },
                            // );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
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
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.error),
                ),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<PengawasanCubit, PengawasanState>(
            builder: (context, state) {
              return LaporanPhotoPicker(
                photo: state.request.buktiFoto,
                onPick: _pickPhoto,
                onRemove: _removePhoto,
              );
            },
          ),
          const SizedBox(height: 24),
          BlocConsumer<PengawasanCubit, PengawasanState>(
            listener: (context, state) {
              if (state.isSuccess) {
                PbShowDialog.show(
                  context,
                  title: "Laporan Berhasil",
                  description: "Laporan pelanggaran kamu sudah tersimpan",
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: AppColors.success,
                  buttonText: "OK",
                  onConfirm: () {
                    Navigator.of(
                      context,
                    ).pop(true); // 🔥 balik + kasih sinyal sukses
                  },
                );
                return;
              }

              if (state.errorMessage != null) {
                PbShowDialog.show(
                  context,
                  title: "Gagal",
                  description: state.errorMessage!,
                  icon: Icons.error_outline_rounded,
                  iconColor: AppColors.error,
                  buttonText: "OK",
                  onConfirm: () {
                    // tetap di screen ini biar user bisa coba lagi
                  },
                );
              }
            },
            builder: (context, state) {
              return PbPrimaryButton(
                text: "Kirim Laporan",
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : _submit,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
