import 'package:flutter/material.dart';

import '../../../../core/design_system/components/chip_indicator/pb_chip_indicator.dart';
import '../../../../core/design_system/components/chip_indicator/pb_chip_type.dart';
import '../../../../core/design_system/components/chip_indicator/pb_radius_type.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/op_pengawas_entity.dart';

class OpPengawasCard extends StatelessWidget {
  final OpPengawasEntity item;
  final VoidCallback? onTap;

  const OpPengawasCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isTju = item.jenisPengawasan == JenisPengawasan.dishub;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: isTju ? AppColors.warning : AppColors.primary,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                              ),
                              child: Text(
                                "KEC.${item.kecamatan}",
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: item.namaOp,
                            style: AppTypography.bodySemiBold.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        PbChipIndicator(
                          labelText: item.jenisPengawasan.label,
                          type: isTju ? PbChipType.success : PbChipType.info,
                          radius: PbRadiusType.full,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_number_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.nop,
                            style: AppTypography.caption.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.alamat,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.caption.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
