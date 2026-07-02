import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

class LaporanPhotoPicker extends StatelessWidget {
  final File? photo;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const LaporanPhotoPicker({
    super.key,
    required this.photo,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (photo == null) {
      return GestureDetector(
        onTap: onPick,
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_rounded,
                size: 28,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                "Ketuk untuk tambah foto",
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.file(
            photo!,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
