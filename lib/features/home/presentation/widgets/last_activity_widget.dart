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

  const LastActivityWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
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
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 🚀 [REFACTOR] CONTENT: Cukup ubah isinya saja berdasarkan data
          if (transactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
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
              separatorBuilder: (_, __) =>
                  const Divider(color: AppColors.border),
              itemBuilder: (context, index) {
                final item = transactions[index];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.isNoPlate ? 'TANPA PLAT' : item.platNumber,
                          style: AppTypography.heading6.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(item.jenisKendaraan, style: AppTypography.caption),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.formattedDate,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          item.formattedNominal,
                          style: AppTypography.bodySemiBold,
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
