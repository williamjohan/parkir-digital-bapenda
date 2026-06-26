import 'package:flutter/material.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/update_entity.dart';
import 'update_progress_dialog.dart';

class ForceUpdateDialog extends StatelessWidget {
  final UpdateEntity update;

  const ForceUpdateDialog({super.key, required this.update});

  static void show(BuildContext context, UpdateEntity update) {
    showDialog(
      context: context,
      barrierDismissible: false, // 🚀 Gembok 1: Tidak bisa klik di luar
      builder: (_) => ForceUpdateDialog(update: update),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 🚀 Gembok 2: Tombol Back HP dimatikan
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              const Text(
                "Pembaruan Wajib",
                style: AppTypography.heading5,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Aplikasi versi lama tidak dapat digunakan lagi. Anda harus memperbarui aplikasi untuk melanjutkan pekerjaan.",
                textAlign: TextAlign.center,
                style: AppTypography.bodyRegular,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(update.changelog, style: AppTypography.caption),
              ),
              const SizedBox(height: 24),
              PbPrimaryButton(
                text: "Update Sekarang",
                onPressed: () {
                  Navigator.of(context).pop();
                  UpdateProgressDialog.show(
                    context,
                    update.downloadUrl,
                    update.versionName,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
