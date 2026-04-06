// lib/features/vehicle_capture/presentation/widgets/vehicle_overlay_guide.dart

import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../domain/entities/vehicle_category.dart';

class VehicleOverlayGuide extends StatelessWidget {
  final VehicleCategory category;

  const VehicleOverlayGuide({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Rasio lebar selalu 80% dari layar
    final double width = MediaQuery.of(context).size.width * 0.8;
    // Rasio tinggi menyesuaikan: Mobil lebih panjang (pipih), Motor lebih mengotak
    final double height = category == VehicleCategory.Mobil
        ? width * 0.35
        : width * 0.6;

    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.success, width: 3),
          borderRadius: BorderRadius.circular(12),
          // Sedikit shadow agar kotak tetap terlihat jika plat berwarna terang
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .2),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}
