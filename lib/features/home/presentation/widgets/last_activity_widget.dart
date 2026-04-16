// lib/features/home/presentation/widgets/last_activity_widget.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
// Pastikan import model Anda sudah benar sesuai path project Anda
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_model.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';

import '../../../../core/routes/app_routes.dart';

class LastActivityWidget extends StatelessWidget {
  final List<HistoryItemModel> transactions;
  final bool isFree;

  const LastActivityWidget({
    super.key,
    required this.transactions,
    this.isFree = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Tambahkan warna dasar putih
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12), // Sedikit diperhalus sudutnya
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.02,
            ), // Bayangan sangat tipis agar elegan
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Transaksi terbaru",
                style: AppTypography.bodySemiBold,
              ),
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.history);
                },
                child: Text(
                  "Lihat Semua",
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold, // Dipertegas sedikit
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (transactions.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: isFree ? 200 : 32,
                ),
                child: Text(
                  'Belum ada transaksi hari ini',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (_, __) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Divider(
                  color: Colors.grey.shade200,
                ), // Divider yang lebih lembut
              ),
              itemBuilder: (context, index) {
                final item = transactions[index];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🚀 1. ICON KENDARAAN (Kecil, Bulat & Elegan)
                    Container(
                      padding: const EdgeInsets.all(10), // Ukuran proporsional
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Icon(
                        item.vehicleIcon, // 🚀 Panggil dari Extension!
                        size: 18, // Ukuran icon lebih kecil dari history card
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 🚀 2. INFORMASI PLAT & JENIS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.titleText,
                            style: AppTypography.heading6.copyWith(
                              color: AppColors.primaryDark,
                              fontSize: 14, // Teks tidak terlalu mendominasi
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.jenisKendaraan,
                            style: AppTypography.caption.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🚀 3. TANGGAL & NOMINAL
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.formattedDate
                              .split('•')
                              .last
                              .trim(), // Opsional: Hanya tampilkan jamnya saja (karena ini transaksi "Hari Ini")
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.formattedNominal,
                          style: AppTypography.bodySemiBold.copyWith(
                            // 🚀 Warna Dinamis: Hijau jika Gratis, Hitam/Primary jika Bayar
                            color: item.isFreeTransaction
                                ? Colors.green
                                : AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
