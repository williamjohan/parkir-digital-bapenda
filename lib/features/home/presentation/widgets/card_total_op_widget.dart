import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import 'package:parkir_digital_bapenda/core/utils/number_formatter.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardTotalOpWidget extends StatelessWidget {
  final int totalObjekPajak;
  final double digitalPercent;
  final int jmlDigital;
  final int jmlEdc;
  final int jmlQris;
  final int jmlCctv;
  final int jmlTs;
  final int jmlProsesDigital;
  final int jmlGratis;
  final VoidCallback? lihatSemuaOnPressed;
  final VoidCallback? onTapDigital;
  final VoidCallback? onTapProses;
  final VoidCallback? onTapGratis;

  const CardTotalOpWidget({
    super.key,
    required this.totalObjekPajak,
    required this.digitalPercent,
    required this.jmlDigital,
    required this.jmlEdc,
    required this.jmlQris,
    required this.jmlCctv,
    required this.jmlTs,
    required this.jmlProsesDigital,
    required this.jmlGratis,
    required this.lihatSemuaOnPressed,
    required this.onTapDigital,
    required this.onTapProses,
    required this.onTapGratis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// === HEADER ===
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TOTAL OBJEK PAJAK PARKIR",
                      style: AppTypography.bodySemiBold.copyWith(
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      NumberFormatter.format(totalObjekPajak.toString()),
                      style: AppTypography.heading1.copyWith(
                        color: AppColors.primary,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Objek terdaftar di sistem",
                      style: AppTypography.caption.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.domain_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// === LINE INDICATOR DIGITAL & PROSES ===
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Progres Digitalisasi",
                    style: AppTypography.caption.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$digitalPercent %",
                    style: AppTypography.bodySemiBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: digitalPercent / 100,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${NumberFormatter.format(jmlDigital.toString())} Digital + ${NumberFormatter.format(jmlProsesDigital.toString())} Proses Digital",
                style: AppTypography.caption.copyWith(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),

          /// === 1. CARD DIGITAL (WITH GRID BREAKDOWN) ===
          _statusItem(
            icon: Icons.qr_code_scanner_rounded,
            iconColor: AppColors.success,
            bgColor: AppColors.success.withValues(alpha: 0.12),
            title: "Digital",
            subtitle: "Sudah terintegrasi sistem digital",
            total: jmlDigital,
            onTap: onTapDigital,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.3,
                children: [
                  _miniInstrumentCard(
                    title: "EDC",
                    value: jmlEdc,
                    icon: Icons.credit_card_rounded,
                  ),
                  _miniInstrumentCard(
                    title: "QRIS Rompi",
                    value: jmlQris,
                    icon: Icons.qr_code_2_rounded,
                  ),
                  _miniInstrumentCard(
                    title: "CCTV",
                    value: jmlCctv,
                    icon: Icons.videocam_rounded,
                  ),
                  _miniInstrumentCard(
                    title: "TS",
                    value: jmlTs,
                    icon: Icons.touch_app_rounded,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          /// === 2. CARD PROSES DIGITAL ===
          _statusItem(
            icon: Icons.hourglass_top_rounded,
            iconColor: AppColors.primaryLight,
            bgColor: AppColors.primaryLight.withValues(alpha: 0.12),
            title: "Proses Digital",
            subtitle: "Dalam tahap integrasi/survei",
            total: jmlProsesDigital,
            onTap: onTapProses,
          ),
          const SizedBox(height: 14),

          /// === 3. CARD GRATIS ===
          _statusItem(
            icon: Icons.money_off_rounded,
            iconColor: AppColors.info,
            bgColor: AppColors.info.withValues(alpha: 0.12),
            title: "Gratis",
            subtitle: "Tidak dikenakan tarif parkir",
            total: jmlGratis,
            onTap: onTapGratis,
          ),

          const SizedBox(height: 24),

          /// === TOMBOL LIHAT SEMUA ===
          PbPrimaryButton(
            text: "Lihat Semua Objek Pajak",
            size: PbButtonSize.medium,
            variant: PbButtonVariant.outlinedPrimary,
            onPressed: lihatSemuaOnPressed,
          ),
        ],
      ),
    );
  }

  /// WIDGET CARD UTAMA (REUSABLE)
  Widget _statusItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required int total,
    required VoidCallback? onTap,
    Widget? child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade100),
          color: Colors.grey.shade50,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.bodySemiBold),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.caption.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  NumberFormatter.format(total.toString()),
                  style: AppTypography.heading2,
                ),
              ],
            ),
            if (child != null) child,
          ],
        ),
      ),
    );
  }

  /// WIDGET MINI UNTUK INSTRUMEN DIGITAL (EDC, QRIS, DLL)
  Widget _miniInstrumentCard({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTypography.caption.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  NumberFormatter.format(value.toString()),
                  style: AppTypography.bodySemiBold.copyWith(
                    color: Colors.grey.shade800,
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
