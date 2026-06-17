import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardObjekPajakWidget extends StatelessWidget {
  final String nop;
  final String? namaLokasi;

  const CardObjekPajakWidget({
    super.key,
    required this.nop,
    required this.namaLokasi,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.store, size: 28, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(namaLokasi ?? '', style: AppTypography.bodySemiBold),
                Text("NOP : $nop", style: AppTypography.bodyRegular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
