// lib/features/home/presentation/widgets/last_activity_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_model.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';

import '../../../../core/routes/app_routes.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class LastActivityWidget extends StatelessWidget {
  const LastActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.recentTransactions != current.recentTransactions ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        final transactions = state.recentTransactions;
        final isLoading = state.isLoading;

        // Tampilkan empty state jika tidak ada transaksi dan tidak loading
        if (!isLoading && transactions.isEmpty) {
          return _buildEmptyStateWidget(context);
        }

        // Tampilkan data transaksi (termasuk saat loading dengan data lama)
        if (transactions.isNotEmpty) {
          return _buildTransactionListWidget(context, transactions);
        }

        // Default: tampilkan empty state
        return _buildEmptyStateWidget(context);
      },
    );
  }

  /// Empty state widget
  Widget _buildEmptyStateWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Transaksi terbaru", style: AppTypography.bodySemiBold),
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
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada transaksi',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Transaksi akan muncul di sini',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Transaction list widget
  Widget _buildTransactionListWidget(
    BuildContext context,
    List<HistoryItemModel> transactions,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Transaksi terbaru", style: AppTypography.bodySemiBold),
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

          /// LIST TRANSAKSI REAL DARI API
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length > 5 ? 5 : transactions.length,
            separatorBuilder: (_, __) => const Divider(color: AppColors.border),
            itemBuilder: (context, index) {
              final item = transactions[index];
              return _buildTransactionItem(item);
            },
          ),
        ],
      ),
    );
  }

  /// Single transaction item
  Widget _buildTransactionItem(HistoryItemModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Left side - Plat & Jenis Kendaraan
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(item.vehicleIcon, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      item.isNoPlate ? 'TANPA PLAT' : item.platNumber,
                      style: AppTypography.heading6.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.jenisKendaraan,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            /// Right side - Time & Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.formattedDate,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: item.badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.formattedNominal,
                    style: AppTypography.bodySemiBold.copyWith(
                      fontSize: 14,
                      color: item.badgeColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
