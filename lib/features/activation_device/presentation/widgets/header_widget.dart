import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.phone_android, color: Colors.white, size: 40),
        ),
        SizedBox(height: 24),
        Text("Aktivasi Device", style: AppTypography.heading1),
        SizedBox(height: 4),
        Text(
          "Masukkan NOP untuk mengaktifkan perangkat Anda.",
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
