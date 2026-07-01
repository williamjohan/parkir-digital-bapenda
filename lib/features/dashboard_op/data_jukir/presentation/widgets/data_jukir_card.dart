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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BAGIAN ATAS: Informasi Shift, Riwayat, dan Rekap Pendapatan
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
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
                    TextButton.icon(
                      onPressed: lihatRiwayatOnTap,
                      icon: const Icon(Icons.history, size: 18),
                      label: const Text("Lihat Riwayat"),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  "Rekap Pendapatan",
                  style: AppTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

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
                          value: entity
                              .totalNominal, // Menggunakan totalNominal dari entitas
                          icon: Icons.payments_outlined,
                          isKendaraan: false,
                        ),
                      ),
                      Expanded(
                        child: _SummaryItem(
                          title: "Motor",
                          value: entity
                              .totalMotorHariIni, // Menggunakan total motor dari entitas
                          icon: Icons.two_wheeler,
                        ),
                      ),
                      Expanded(
                        child: _SummaryItem(
                          title: "Mobil",
                          value: entity
                              .totalMobilHariIni, // Menggunakan total mobil dari entitas
                          icon: Icons.directions_car,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),

          // BAGIAN BAWAH: List Jukir
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daftar Jukir",
                  style: AppTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                // Looping data jukir dari usernameList
                ...entity.usernameList.map(
                  (jukir) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _JukirItem(jukir: jukir),
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

class _JukirItem extends StatelessWidget {
  final UsernameEntity jukir;

  const _JukirItem({required this.jukir});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Color(0xFFE9F2FF),
          child: Icon(Icons.person, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jukir.namaPetugas,
                style: AppTypography.bodyRegular.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "username : ${jukir.username}",
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "password : ${jukir.username}", // Sesuai dengan source awal
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
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
