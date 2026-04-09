import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
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
          previous.recentTransactions != current.recentTransactions,
      builder: (context, state) {
        final transactions = state.recentTransactions;

        if (transactions.isEmpty) {
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
                    Text(
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
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'Belum ada transaksi hari ini',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

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
                itemCount: transactions.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: AppColors.border),
                itemBuilder: (context, index) {
                  final item = transactions[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                              Text(item.jenisKendaraan),
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
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
