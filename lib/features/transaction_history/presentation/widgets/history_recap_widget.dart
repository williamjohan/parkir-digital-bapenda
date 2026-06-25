import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'history_item_widget.dart';

class HistoryRecapWidget extends StatelessWidget {
  final String title;
  final String roda2;
  final String roda4;
  final String totalPendapatan;
  final String persentasePajak;
  final String nominalPajak;
  final String totalBersih;
  final bool isFree;

  // Parameter Baru
  final bool isRealisasiAvailable;
  final int realisasiDigital;
  final int realisasiNonDigital;

  const HistoryRecapWidget({
    super.key,
    required this.title,
    required this.roda2,
    required this.roda4,
    required this.totalPendapatan,
    required this.persentasePajak,
    required this.nominalPajak,
    required this.totalBersih,
    this.isFree = true,
    this.isRealisasiAvailable = false, // Default false jika tidak dikirim
    this.realisasiDigital = 0,
    this.realisasiNonDigital = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // === HEADER: JUDUL ===
          Text(title.toUpperCase(), style: AppTypography.caption),
          const SizedBox(height: 12),

          if (!isFree) ...[
            // ==========================================
            // BARIS 1: FINANSIAL (3 KOLOM SAMA RATA)
            // ==========================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- KOLOM 1: KOTOR ---
                Expanded(
                  child: _buildFinancialColumn(
                    label: "Kotor",
                    value: CurrencyFormatter.toIdr(totalPendapatan),
                    valueColor: AppColors.textPrimary,
                  ),
                ),

                _buildVerticalDivider(),

                // --- KOLOM 2: PAJAK ---
                Expanded(
                  child: _buildFinancialColumn(
                    label: "Pajak ($persentasePajak%)",
                    value: "- ${CurrencyFormatter.toIdr(nominalPajak)}",
                    valueColor: AppColors.error,
                  ),
                ),

                _buildVerticalDivider(),

                // --- KOLOM 3: BERSIH ---
                Expanded(
                  child: _buildFinancialColumn(
                    label: "Bersih",
                    value: CurrencyFormatter.toIdr(totalBersih),
                    valueColor: AppColors.success,
                  ),
                ),
              ],
            ),

            // Garis Pemisah Horizontal setelah Finansial
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
          ],

          // ==========================================
          // BARIS BARU: REALISASI (DIGITAL VS NON-DIGITAL)
          // ==========================================
          if (isRealisasiAvailable) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFinancialColumn(
                  label: "Realisasi Digital",
                  value: CurrencyFormatter.toIdr(realisasiDigital),
                  valueColor: AppColors.primary,
                ),
                _buildVerticalDivider(),
                _buildFinancialColumn(
                  label: "Realisasi Non-Digital",
                  value: CurrencyFormatter.toIdr(realisasiNonDigital),
                  valueColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          // ==========================================
          // BARIS 2: METRIK KENDARAAN (2 KOLOM SAMA RATA)
          // ==========================================
          if (isRealisasiAvailable == false)
            Row(
              children: [
                Expanded(
                  child: HistoryRecapItem(
                    title: "Roda 2",
                    subTitle: "Transaksi",
                    value: roda2,
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.border),
                const SizedBox(width: 12),
                Expanded(
                  child: HistoryRecapItem(
                    title: "Roda 4",
                    subTitle: "Transaksi",
                    value: roda4,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // 🚀 HELPER: Komponen Kolom Finansial Anti-Gencet
  Widget _buildFinancialColumn({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTypography.heading4.copyWith(color: valueColor),
          ),
        ),
      ],
    );
  }

  // 🚀 HELPER: Garis Vertikal Pemisah
  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
