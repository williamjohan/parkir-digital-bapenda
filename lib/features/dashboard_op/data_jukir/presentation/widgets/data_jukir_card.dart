import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';
import 'package:parkir_digital_bapenda/core/utils/number_formatter.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/data_jukir_entity.dart';

class DataJukirCard extends StatelessWidget {
  final DataJukirEntity entity;
  final VoidCallback? lihatRiwayatOnTap;

  const DataJukirCard({
    super.key,
    required this.entity,
    required this.lihatRiwayatOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFE9F2FF),
                  child: Icon(Icons.person, color: AppColors.primary, size: 34),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              entity.namaPetugas,
                              style: AppTypography.heading6,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Shift ${entity.shift}",
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      Text(
                        "username : ${entity.username}",
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        "password : ${entity.username}",
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: Column(
              children: [
                // const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Rekap Pendapatan",
                        style: AppTypography.bodyRegular.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: lihatRiwayatOnTap,
                        icon: const Icon(Icons.history, size: 18),
                        label: const Text("Lihat Riwayat"),
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryItem(
                          title: "Pendapatan",
                          // value: entity.totalPendapatan,
                          value: 0,
                          icon: Icons.payments_outlined,
                          isKendaraan: false,
                        ),
                      ),
                      Expanded(
                        child: _SummaryItem(
                          title: "Motor",
                          // value: entity.totalMotor,
                          value: 0,
                          icon: Icons.two_wheeler,
                        ),
                      ),
                      Expanded(
                        child: _SummaryItem(
                          title: "Mobil",
                          // value: entity.totalMobil,
                          value: 0,
                          icon: Icons.directions_car,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: AppTypography.bodyRegular.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final bool isKendaraan;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.icon,
    this.isKendaraan = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 4),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            (isKendaraan
                ? NumberFormatter.format(value)
                : CurrencyFormatter.toIdr(value)),
            style: AppTypography.heading6.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
