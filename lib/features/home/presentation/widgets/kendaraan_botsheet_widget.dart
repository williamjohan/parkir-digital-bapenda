import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class KendaraanBottomSheetWidget extends StatelessWidget {
  final bool isTanpaPlat;
  final VoidCallback? onTapMotor;
  final VoidCallback? onTapMobil;

  const KendaraanBottomSheetWidget({
    super.key,
    this.isTanpaPlat = true,
    required this.onTapMobil,
    required this.onTapMotor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Handle (garis kecil atas)
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 8),

          /// Title
          Text(
            isTanpaPlat
                ? "Kendaraan masuk — tanpa plat"
                : "Kendaraan masuk — pakai plat",
            style: AppTypography.heading4,
          ),

          const SizedBox(height: 4),

          Text(
            "Pilih jenis kendaraan. Tarif dihitung otomatis.",
            style: AppTypography.bodySmall.copyWith(color: Colors.grey),
          ),

          const SizedBox(height: 16),

          /// Options
          Row(
            children: [
              Expanded(
                child: _buildItem(
                  title: "Motor",
                  price: "Rp 2.000 / masuk",
                  icon: Icons.two_wheeler,
                  value: "motor",
                  ontap: onTapMotor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildItem(
                  title: "Mobil",
                  price: "Rp 5.000 / masuk",
                  icon: Icons.directions_car,
                  value: "mobil",
                  ontap: onTapMobil,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required String price,
    required IconData icon,
    required String value,
    required VoidCallback? ontap,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: AppColors.primaryDark),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTypography.bodyRegular.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: AppTypography.bodySmall.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
