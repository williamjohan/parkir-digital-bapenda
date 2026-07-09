import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';

class TarifEmptyWidget extends StatelessWidget {
  const TarifEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ penting
        children: [
          Icon(Icons.no_transfer_outlined, size: 80, color: AppColors.textHint),

          SizedBox(height: 24),
          Text(
            "Kendaraan & tarif belum diatur",
            style: TextStyle(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
