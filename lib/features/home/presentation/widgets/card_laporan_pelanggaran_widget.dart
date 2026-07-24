import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/routes/app_routes.dart';
import 'package:parkir_digital_bapenda/core/utils/number_formatter.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardLaporanPelanggaranWidget extends StatelessWidget {
  final int laporanPelanggaran;

  const CardLaporanPelanggaranWidget({
    super.key,
    required this.laporanPelanggaran,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(AppRoutes.laporanPelanggaran);
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Laporan Pelanggaran",
                    style: AppTypography.bodySemiBold,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Jumlah laporan yang masuk hari ini",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Text(
              NumberFormatter.format(laporanPelanggaran.toString()),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
