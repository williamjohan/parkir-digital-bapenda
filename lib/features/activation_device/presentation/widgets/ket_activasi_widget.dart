import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class KetAktivasiWidget extends StatelessWidget {
  const KetAktivasiWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.phone_android_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Satu Device, Satu Akun",
                      style: AppTypography.bodySemiBold,
                    ),
                    Text(
                      "NOP hanya bisa digunakan di device yang teraktivasi",
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.security, color: AppColors.primary, size: 20),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Proteksi Akun", style: AppTypography.bodySemiBold),
                    Text(
                      "Cegah akses tidak sah dari device lain",
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
