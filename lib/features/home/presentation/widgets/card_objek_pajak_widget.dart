import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardObjekPajakWidget extends StatelessWidget {
  final String nop;
  final String? namaObjekPajak;
  final String? alamat;
  final VoidCallback? onPressedGantiObjek;
  final VoidCallback? onPressedLihatDetail;

  const CardObjekPajakWidget({
    super.key,
    required this.nop,
    required this.namaObjekPajak,
    required this.alamat,
    required this.onPressedGantiObjek,
    required this.onPressedLihatDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ), // Padding diperbesar sedikit untuk napas
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.store, size: 32, color: Colors.white),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(namaObjekPajak ?? '', style: AppTypography.heading4),
                    Text("NOP  $nop", style: AppTypography.bodyRegular),
                    Text(alamat ?? '-', style: AppTypography.caption),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PbPrimaryButton(
                  text: "Ganti Objek",
                  size: PbButtonSize.small,
                  iconLeft: Icons.swap_horiz,
                  variant: PbButtonVariant.outlinedPrimary,
                  onPressed: onPressedGantiObjek,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PbPrimaryButton(
                  text: "Lihat Detail",
                  size: PbButtonSize.small,
                  iconLeft: Icons.info_outline,
                  variant: PbButtonVariant.primary,
                  onPressed: onPressedLihatDetail,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
