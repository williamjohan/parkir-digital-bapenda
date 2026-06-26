import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';

enum PbChipType { success, warning, error, info, idle }

extension PbChipTypeExtension on PbChipType {
  Color get backgroundColor {
    switch (this) {
      case PbChipType.success:
        return AppColors.success.withValues(alpha: 0.1);
      case PbChipType.warning:
        return AppColors.warning.withValues(alpha: 0.1);
      case PbChipType.error:
        return AppColors.error.withValues(alpha: 0.1);
      case PbChipType.info:
        return AppColors.info.withValues(alpha: 0.1);
      case PbChipType.idle:
        return AppColors.disabled.withValues(alpha: 0.1);
    }
  }

  Color get foregroundColor {
    switch (this) {
      case PbChipType.success:
        return AppColors.success;
      case PbChipType.warning:
        return AppColors.warning;
      case PbChipType.error:
        return AppColors.error;
      case PbChipType.info:
        return AppColors.info;
      case PbChipType.idle:
        return AppColors.disabled;
    }
  }

  BorderSide? get border {
    switch (this) {
      case PbChipType.success:
        return BorderSide(color: AppColors.success);
      case PbChipType.warning:
        return BorderSide(color: AppColors.warning);
      case PbChipType.error:
        return BorderSide(color: AppColors.error);
      case PbChipType.info:
        return BorderSide(color: AppColors.info);
      case PbChipType.idle:
        return BorderSide(color: AppColors.disabled);
    }
  }
}
