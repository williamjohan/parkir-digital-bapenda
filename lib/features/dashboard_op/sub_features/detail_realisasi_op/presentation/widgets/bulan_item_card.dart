import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';

class BulanItemCard extends StatelessWidget {
  final String bulan;
  final String sspd;
  final double nominalNonDigital;
  final double nominalDigital;
  final double totalNominal;

  const BulanItemCard({
    super.key,
    required this.bulan,
    required this.sspd,
    required this.nominalNonDigital,
    required this.nominalDigital,
    required this.totalNominal,
  });

  @override
  Widget build(BuildContext context) {
    // 🚀 LOGIKA PRESENTASI DI SINI
    final bool hasBoth = nominalNonDigital > 0 && nominalDigital > 0;
    final bool onlyDigital = nominalNonDigital == 0 && nominalDigital > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── HEADER (Bulan & SSPD) ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bulan,
                style: AppTypography.bodySemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                sspd,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.border),
          ),

          // ─── KONTEN DINAMIS BERDASARKAN LOGIKA ───
          if (hasBoth) ...[
            _buildNominalRow('Realisasi Non digital', nominalNonDigital),
            const SizedBox(height: 8),
            _buildNominalRow('Realisasi Digital', nominalDigital),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                height: 1,
                color: AppColors.border,
                // style: BorderStyle.solid,
              ), // Bisa pakai dash line jika ada
            ),
            _buildNominalRow('Total $bulan', totalNominal, isTotal: true),
          ] else if (onlyDigital) ...[
            _buildNominalRow(
              'Realisasi Digital',
              nominalDigital,
              isTotal: true,
            ),
          ] else ...[
            // Kondisi Default / Hanya Non-Digital
            _buildNominalRow('Realisasi', totalNominal, isTotal: true),
          ],
        ],
      ),
    );
  }

  // ─── HELPER WIDGET UNTUK BARIS ───
  Widget _buildNominalRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyRegular.copyWith(
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          CurrencyFormatter.toIdr(value.toInt()),
          style: AppTypography.bodySemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
