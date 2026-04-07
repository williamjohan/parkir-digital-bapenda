import 'package:flutter/material.dart';

import '../../../core/design_system/tokens/app_colors.dart';
import '../../../core/design_system/tokens/app_typography.dart';

class CardJenisKendaraan extends StatefulWidget {
  final Function(String value)? onSelected;

  const CardJenisKendaraan({super.key, this.onSelected});

  @override
  State<CardJenisKendaraan> createState() => _CardJenisKendaraanState();
}

class _CardJenisKendaraanState extends State<CardJenisKendaraan> {
  String? selectedValue;

  void _onSelect(String value) {
    setState(() {
      selectedValue = value;
    });

    if (widget.onSelected != null) {
      widget.onSelected!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "JENIS KENDARAAN",
            style: AppTypography.heading6.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildItem(
                  title: "Motor",
                  price: "Rp2.000",
                  icon: Icons.two_wheeler,
                  isSelected: selectedValue == "Motor",
                  onTap: () => _onSelect("Motor"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildItem(
                  title: "Mobil",
                  price: "Rp5.000",
                  icon: Icons.directions_car,
                  isSelected: selectedValue == "Mobil",
                  onTap: () => _onSelect("Mobil"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildItem({
  required String title,
  required String price,
  required IconData icon,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? AppColors.primary : AppColors.primaryDark,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTypography.bodyRegular.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : Colors.black,
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
