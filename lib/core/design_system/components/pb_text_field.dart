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
  final Function(String)? onChanged;

  const PbTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.isLoading = false,
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
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          onChanged: onChanged,
          textCapitalization:
              TextCapitalization.characters, // Otomatis Huruf Besar
          inputFormatters: [
            // Memastikan jukir tidak memasukkan simbol aneh
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9 ]')),
          ],
          style: AppTypography.heading2.copyWith(letterSpacing: 2),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.heading2.copyWith(
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.edit, color: AppColors.primary, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textHint),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textHint),
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
