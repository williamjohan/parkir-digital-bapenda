import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';

import '../../domain/entities/dashboard_op_entity.dart';

class CardRiwayatPendapatanOp extends StatelessWidget {
  const CardRiwayatPendapatanOp({
    super.key,
    required this.totalMotor,
    required this.totalMobil,
    required this.riwayat,
    this.onLihatSemua,
  });

  final int totalMotor;
  final int totalMobil;
  final List<RiwayatPendapatanEntity> riwayat;
  final VoidCallback? onLihatSemua;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Riwayat pendapatan',
                  style: AppTypography.bodySemiBold,
                ),
              ),
              InkWell(
                onTap: onLihatSemua,
                child: Row(
                  children: [
                    Text(
                      'Lihat semua',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // const Divider(color: AppColors.border, height: 1),
          Text('Hari ini', style: AppTypography.bodySemiBold),
          SizedBox(height: 12),
          Column(
            children: [
              /// Summary kendaraan
              Row(
                children: [
                  Expanded(
                    child: _VehicleSummaryCard(
                      isRoda2: true,
                      value: totalMotor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _VehicleSummaryCard(
                      isRoda2: false,
                      value: totalMobil,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// List Riwayat
              ...riwayat.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _RiwayatItem(
                    item: item,
                    currency: CurrencyFormatter.toIdr,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VehicleSummaryCard extends StatelessWidget {
  const _VehicleSummaryCard({required this.isRoda2, required this.value});

  final bool isRoda2;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isRoda2 ? Colors.teal.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isRoda2 ? Icons.directions_bike : Icons.directions_car,
            size: 20,
            color: isRoda2 ? Colors.teal.shade600 : Colors.blue.shade700,
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Text(
                isRoda2 ? 'Motor' : 'Mobil',
                style: AppTypography.caption.copyWith(
                  color: isRoda2 ? Colors.teal.shade600 : Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.toString(),
                style: AppTypography.bodySemiBold.copyWith(
                  color: isRoda2 ? Colors.teal.shade600 : Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiwayatItem extends StatelessWidget {
  final RiwayatPendapatanEntity item;
  final String Function(int) currency;

  const _RiwayatItem({required this.item, required this.currency});

  @override
  Widget build(BuildContext context) {
    // final isMotor = item.jenisKendaraan.toLowerCase() == 'motor';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${item.jenisKendaraan} · ${item.tgl}',
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),

        Text(
          currency(item.kredit),
          textAlign: TextAlign.end,
          style: AppTypography.bodySemiBold,
        ),
      ],
    );
  }
}
