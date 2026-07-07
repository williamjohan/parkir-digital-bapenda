import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/presentation/widgets/laporan_section_card.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class KeteranganSectionCard extends StatelessWidget {
  final TextEditingController keteranganController;

  const KeteranganSectionCard({super.key, required this.keteranganController});

  @override
  Widget build(BuildContext context) {
    return LaporanSectionCard(
      title: "Keterangan",
      icon: Icons.notes_rounded,
      child: TextFormField(
        controller: keteranganController,
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
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }
}
