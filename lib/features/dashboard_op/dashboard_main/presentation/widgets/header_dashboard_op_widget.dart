import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

class HeaderDashboardOp extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onPressedLihatDaftarJukir;

  const HeaderDashboardOp({
    super.key,
    required this.item,
    required this.onPressedLihatDaftarJukir,
  });

  @override
  Widget build(BuildContext context) {
    // final pajakNominal = (totalPendapatan * (pajakPercent / 100)).round();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight, // Oranye agak terang di atas
            AppColors.primaryDark, // Oranye gelap di bawah
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: AppColors.background.withValues(alpha: 0.06),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: AppColors.textPrimary.withValues(alpha: 0.04),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Badge Status Digital & Info Atas
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item['statusDigitalisasi'],
                        style: AppTypography.caption.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '•  UPTB ${item['uptb'] ?? '-'}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Nama OP (Dibuat lebih tegas)
                Text(
                  item['nama_op'] ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.heading1.copyWith(
                    color: AppColors.background,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${item['alamat_op'] ?? '-'}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.background,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['nop'],
                  style: AppTypography.caption.copyWith(
                    color: AppColors.background,
                  ),
                ),

                const SizedBox(height: 10),
                const Row(
                  children: [Expanded(child: Divider(color: AppColors.border))],
                ),
                const SizedBox(height: 10),
                PbPrimaryButton(
                  text: "Lihat Daftar Jukir",
                  variant: PbButtonVariant.outlinedSecondaryLight,
                  onPressed: onPressedLihatDaftarJukir,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
