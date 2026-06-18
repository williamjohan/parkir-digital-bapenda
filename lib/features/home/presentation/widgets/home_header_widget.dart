import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String namaJukir;
  final String nop;
  final String? namaObjekPajak;
  final bool? isJukir;
  final VoidCallback? onPressed;

  const HomeHeaderWidget({
    super.key,
    required this.namaJukir,
    required this.nop,
    this.namaObjekPajak,
    required this.isJukir,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isJukir == false) ...[
                Text(
                  "TAX PARK",
                  style: AppTypography.bodySemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "BAPENDA KOTA SURABAYA",
                  style: AppTypography.caption.copyWith(color: Colors.white),
                ),
              ],
              Text(
                "Hallo, $namaJukir !",
                style: AppTypography.heading1.copyWith(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (isJukir == true) ...[
                Text(
                  "NOP : $nop",
                  style: AppTypography.bodyRegular.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  namaObjekPajak ?? '',
                  style: AppTypography.bodySemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
              // if (isJukir == false) ...[
              //   SizedBox(height: 8),
              //   PbPrimaryButton(
              //     text: "Cari objek pajak...",
              //     variant: PbButtonVariant.outlinedSecondaryLight,
              //     size: PbButtonSize.small,
              //     iconRight: Icons.search,
              //     onPressed: onPressed,
              //   ),
              // ],
            ],
          ),
        ),
        SizedBox(width: 16),

        // tombol menu
        Builder(
          builder: (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 20),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
      ],
    );
  }
}
