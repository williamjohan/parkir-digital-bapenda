// lib/core/design_system/components/bapenda_text_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class PbTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool isLoading;
  final bool enabled; // BARU: Properti untuk mengunci input
  final Function(String)? onChanged;

  const PbTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.isLoading = false,
    this.enabled = true, // Default tetap true agar tidak merusak halaman lain
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              // Warna label sedikit memudar jika field di-disable
              color: enabled ? AppColors.textPrimary : AppColors.textHint,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled, // BARU: Lempar status ke TextField bawaan
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9 ]')),
          ],
          style: AppTypography.heading2.copyWith(
            fontSize: 20,
            letterSpacing: 2,
            color: enabled ? AppColors.textPrimary : AppColors.textHint,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.bodyRegular.copyWith(
              fontSize: 11,
              color: AppColors.textHint,
            ),
            filled: true,
            // BARU: Jika di-disable, warnanya abu-abu terang (disable state)
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.edit,
                    // Warna icon memudar jika disabled
                    color: enabled ? AppColors.primary : AppColors.textHint,
                    size: 20,
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textHint),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textHint),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              // Border lebih tipis/pudar saat disabled
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
