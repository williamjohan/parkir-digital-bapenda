import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

class ItemKendaraanWidget extends StatelessWidget {
  final IconData icon;
  final String judul;
  final String jumlah;
  final double? width;
  final double? height;
  final bool isLeftIcon;
  final bool isSolid;

  const ItemKendaraanWidget({
    super.key,
    required this.icon,
    required this.judul,
    required this.jumlah,
    this.width,
    this.height,
    this.isLeftIcon = true,
    this.isSolid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSolid ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSolid ? Colors.white : AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLeftIcon) ...[
            Icon(icon, color: isSolid ? Colors.white : AppColors.primary),
            SizedBox(width: 8),
          ],
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isLeftIcon) ...[
                Icon(icon, color: isSolid ? Colors.white : AppColors.primary),
                SizedBox(height: 8),
              ],
              Text(
                judul,
                style: isSolid
                    ? AppTypography.caption.copyWith(color: Colors.white)
                    : AppTypography.caption,
              ),
              Text(
                jumlah,
                style: isSolid
                    ? TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                    : AppTypography.heading4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
