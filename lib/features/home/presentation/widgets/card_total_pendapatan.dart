import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';

class CardTotalPendapatan extends StatelessWidget {
  final String totalKotor;
  final String persentasePajak;
  final String nominalPajak;
  final String totalBersih;
  final bool isShowHariIni;

  const CardTotalPendapatan({
    super.key,
    required this.totalKotor,
    required this.persentasePajak,
    required this.nominalPajak,
    required this.totalBersih,
    this.isShowHariIni = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ), // Padding diperbesar sedikit untuk napas
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // === 1. HEADER & TANGGAL ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (!isShowHariIni) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.money,
                        color: AppColors.success,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                  Text("TOTAL PENDAPATAN", style: AppTypography.bodySemiBold),
                ],
              ),
              if (isShowHariIni)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('d MMM yyyy', 'id_ID').format(DateTime.now()),
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (isShowHariIni)
            Text("Hari ini", style: AppTypography.bodySemiBold),
          if (!isShowHariIni) SizedBox(height: 8),
          // === 2. HERO METRIC (KOTOR) ===
          Text(
            "Pendapatan Kotor",
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              CurrencyFormatter.toIdr(totalKotor),
              style: AppTypography.heading1.copyWith(color: AppColors.primary),
            ),
          ),

          const SizedBox(height: 16),

          // === 3. FINANCIAL DIVIDER ===
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),

          // === 4. BOTTOM ANALYTICS (PAJAK & BERSIH) ===
          Row(
            children: [
              // Kolom Pajak (Kiri)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 14,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Pajak ($persentasePajak%)",
                          style: AppTypography.caption.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "- ${CurrencyFormatter.toIdr(nominalPajak)}",
                      style: AppTypography.bodySemiBold.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),

              // Garis Pemisah Vertikal
              Container(width: 1, height: 30, color: AppColors.border),
              const SizedBox(width: 16),

              // Kolom Bersih (Kanan)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Bersih",
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        CurrencyFormatter.toIdr(totalBersih),
                        style: AppTypography.heading3.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
