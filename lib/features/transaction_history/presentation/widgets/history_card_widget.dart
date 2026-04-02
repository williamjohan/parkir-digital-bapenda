import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/history_item_model.dart';
// Sesuaikan import AppColors & AppTypography dengan sistem desain Anda
// import '../../../../core/design_system/tokens/app_colors.dart';
// import '../../../../core/design_system/tokens/app_typography.dart';

class HistoryCardWidget extends StatelessWidget {
  final HistoryItemModel item;
  final VoidCallback onPreviewTap;

  const HistoryCardWidget({
    super.key,
    required this.item,
    required this.onPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Format Tanggal (Contoh: 01 Apr 2026 • 14:30)
    String formattedDate = item.tglTrx;
    try {
      final DateTime date = DateTime.parse(item.tglTrx);
      formattedDate = DateFormat('dd MMM yyyy • HH:mm').format(date);
    } catch (_) {}

    // 2. Format Uang (Rp)
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final String nominal = formatCurrency.format(item.kredit);

    // 3. Status Badge Logic
    final bool isFree = item.jenisTarif.toUpperCase() == 'FREE';
    final Color badgeColor = isFree ? Colors.green : Colors.blue;
    final String badgeText = isFree ? 'GRATIS' : 'LUNAS';

    // 4. Ikon Kendaraan
    IconData vehicleIcon = Icons.directions_car;
    if (item.jenisTarif.toUpperCase() == 'MOTOR') {
      vehicleIcon = Icons.two_wheeler;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: Tanggal & Badge ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- BODY: Kendaraan, Plat, dan Nominal ---
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(vehicleIcon, color: Colors.black87),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.platNumber == '-' ? 'Tanpa Plat' : item.platNumber,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.jenisTarif == 'FREE'
                            ? 'Parkir Gratis'
                            : item.jenisTarif,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  isFree ? 'Rp 0' : nominal,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.black12),
            const SizedBox(height: 4),

            // --- FOOTER: Info Jukir & Tombol Preview Karcis ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Petugas: ${item.namaPetugas} (Shift ${item.jenisTarif == 'FREE' ? '-' : '1'})', // Fallback shift
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // TOMBOL PREVIEW KARCIS (THE NEXT BIG THING)
                InkWell(
                  onTap: onPreviewTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long, size: 16, color: Colors.blue),
                        SizedBox(width: 6),
                        Text(
                          'Lihat Karcis',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
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
    );
  }
}
