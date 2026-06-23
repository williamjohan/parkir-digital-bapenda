import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import '../../../../core/utils/currency_formatter.dart';

class HeaderDashboardOp extends StatelessWidget {
  const HeaderDashboardOp({
    super.key,
    required this.item,
    required this.totalPendapatan,
    required this.pajakPercent,
    required this.pendapatanBersih,
    required this.isDigital,
  });

  final Map<String, dynamic> item;
  final int totalPendapatan;
  final double pajakPercent;
  final int pendapatanBersih;
  final bool isDigital;

  @override
  Widget build(BuildContext context) {
    final pajakNominal = (totalPendapatan * (pajakPercent / 100)).round();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        // 1. Menggunakan Gradasi agar terlihat mewah & tidak flat
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
          // 2. Dekorasi lingkaran transparan ala kartu premium
          Positioned(
            right: -50,
            top: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: AppColors.background.withOpacity(0.06),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: AppColors.textPrimary.withOpacity(0.04),
            ),
          ),

          // Konten Utama
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
                        color: isDigital
                            ? AppColors.background.withOpacity(0.25)
                            : AppColors.textPrimary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isDigital ? 'Digital' : 'Belum Digital',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '•  UPTB ${item['uptb'] ?? '-'}  •  ${item['alamat_op'] ?? '-'}',
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.heading1.copyWith(
                    color: AppColors.background,
                  ),
                ),

                const SizedBox(height: 5),
                Row(
                  children: [Expanded(child: Divider(color: AppColors.border))],
                ),
                const SizedBox(height: 5),

                /// Area Pendapatan Kotor (Dibuat frameless & clean)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL PENDAPATAN HARI INI',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.background.withOpacity(0.75),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyFormatter.toIdr(totalPendapatan),
                      style: AppTypography.heading1.copyWith(
                        color: AppColors.background,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Baris Potongan Pajak & Pendapatan Bersih (Desain Asimetris)
                Row(
                  children: [
                    // Kartu Pajak (Kombinasi Gelap Transparan tipis)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.background.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pajak (${pajakPercent.toStringAsFixed(0)}%)',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.background.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '- ${CurrencyFormatter.toIdr(pajakNominal)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySemiBold.copyWith(
                                color: AppColors.error.withOpacity(0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Kartu Bersih (Dibuat Pop-Out Putih Solid ala Glassmorphism terbalik)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textPrimary.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pendapatan Bersih',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              CurrencyFormatter.toIdr(pendapatanBersih),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySemiBold.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
