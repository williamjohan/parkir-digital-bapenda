import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/mode_item.dart';

import 'kendaraan_botsheet_widget.dart';

class CardModeTransaksiWidget extends StatelessWidget {
  final VoidCallback? onTapTanpaPlat;
  final VoidCallback? onTapPakaiPlat;

  const CardModeTransaksiWidget({
    super.key,
    required this.onTapPakaiPlat,
    required this.onTapTanpaPlat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Catat Transaksi Parkir", style: AppTypography.bodySemiBold),
          Text(
            "Silahkan pilih mode parkir terlebih dahulu",
            style: AppTypography.caption,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ModeItemWidget(
                title: "Tanpa Plat",
                subTitle: "Langkah cepat",
                icon: Icons.flash_on,
                onTap: onTapTanpaPlat,
              ),
              ModeItemWidget(
                title: "Pakai Plat",
                subTitle: "Scan via kamera",
                icon: Icons.camera_alt,
                onTap: onTapPakaiPlat,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
