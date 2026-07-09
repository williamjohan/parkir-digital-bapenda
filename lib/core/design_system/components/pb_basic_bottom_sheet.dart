import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

class PbBasicBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    String? subTitle,
    bool isScrollControlled = true,
    bool showDivider = false,
    bool normalPadding = true,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: normalPadding
              ? const EdgeInsets.all(24)
              : EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24, top: 24),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              if (title != null) ...[
                Text(
                  title,
                  style: AppTypography.heading6.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              if (subTitle != null) ...[
                Text(
                  subTitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (showDivider == true) const Divider(),

              child,
            ],
          ),
        );
      },
    );
  }
}
