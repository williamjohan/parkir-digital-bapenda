import 'package:flutter/material.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/utils/currency_formatter.dart';

class CardTaxSurveillance extends StatelessWidget {
  /// contoh: "Hari Ini" atau "Bulan Ini" — dipasang di belakang judul
  final String month;
  final int totalNominal;
  final int nominalMotor;
  final int nominalMobil;
  final VoidCallback onLihatSemua;

  const CardTaxSurveillance({
    super.key,
    required this.month,
    required this.totalNominal,
    required this.nominalMotor,
    required this.nominalMobil,
    required this.onLihatSemua,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.policy_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Tax Surveillance Bulan $month",
                  style: AppTypography.bodySemiBold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onLihatSemua,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Lihat Semua",
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.toIdr(totalNominal),
            style: AppTypography.heading1.copyWith(
              fontSize: 30,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 4),
          Text(
            "Total Nominal Pengawasan",
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 4),
          const Divider(color: AppColors.border),
          const SizedBox(height: 4),

          Row(
            children: [
              Expanded(
                child: _VehicleAmount(
                  icon: Icons.two_wheeler_rounded,
                  label: "Motor",
                  nominal: nominalMotor,
                  color: AppColors.success,
                ),
              ),
              Container(width: 1, height: 52, color: AppColors.border),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: _VehicleAmount(
                    icon: Icons.directions_car_rounded,
                    label: "Mobil",
                    nominal: nominalMobil,
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VehicleAmount extends StatelessWidget {
  final IconData icon;
  final String label;
  final int nominal;
  final Color color;

  const _VehicleAmount({
    required this.icon,
    required this.label,
    required this.nominal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(CurrencyFormatter.toIdr(nominal), style: AppTypography.bodySemiBold.copyWith(color: color)),
      ],
    );
  }
}
