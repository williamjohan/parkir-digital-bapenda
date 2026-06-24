import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/domain/entities/dashboard_op_entity.dart';

class CardRekapJenisPembayaranOp extends StatelessWidget {
  const CardRekapJenisPembayaranOp({
    super.key,
    required this.items,
    this.onLihatSemua,
  });

  final List<SofEntity> items;
  final VoidCallback? onLihatSemua;

  @override
  Widget build(BuildContext context) {
    final maxValue = items
        .expand((e) => [e.nominalMotor, e.nominalMobil])
        .fold<int>(0, (prev, value) => value > prev ? value : prev);

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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Icon(
                  Icons.credit_card,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jenis Pembayaran',
                      style: AppTypography.bodySemiBold,
                    ),
                    const SizedBox(height: 2),
                    const Text('Hari Ini', style: AppTypography.bodySemiBold),
                  ],
                ),
              ),

              // 🚀 Kolom 3: Tombol Aksi
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
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color:
                          Colors.orange, // Sesuaikan jika ada AppColors.primary
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...items
              .take(3)
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _PaymentItem(
                    item: item,
                    maxValue: maxValue,
                    formatCurrency: CurrencyFormatter.toIdr,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _PaymentItem extends StatelessWidget {
  const _PaymentItem({
    required this.item,
    required this.maxValue,
    required this.formatCurrency,
  });

  final SofEntity item;
  final int maxValue;
  final String Function(int) formatCurrency;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            item.sof,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySemiBold,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            children: [
              _BarRow(
                icon: Icons.two_wheeler,
                nominal: item.nominalMotor,
                jumlah: item.jumlahMotor,
                maxValue: maxValue,
                formatCurrency: formatCurrency,
              ),
              const SizedBox(height: 8),
              _BarRow(
                icon: Icons.directions_car,
                nominal: item.nominalMobil,
                jumlah: item.jumlahMobil,
                maxValue: maxValue,
                formatCurrency: formatCurrency,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({
    required this.icon,
    required this.nominal,
    required this.jumlah,
    required this.maxValue,
    required this.formatCurrency,
  });

  final IconData icon;
  final int nominal;
  final int jumlah;
  final int maxValue;
  final String Function(int) formatCurrency;

  @override
  Widget build(BuildContext context) {
    final percent = maxValue == 0 ? 0.0 : nominal / maxValue;

    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.orange),

        const SizedBox(width: 8),

        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: const Color(0xFFEDEDED),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFE58E00)),
            ),
          ),
        ),
        SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            formatCurrency(nominal),
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
