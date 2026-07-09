import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';
import 'package:parkir_digital_bapenda/core/utils/number_formatter.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/dashboard_summary_non_jukir_entity.dart';

class CardRekapJenisPembayaranWidget extends StatelessWidget {
  final bool isShowPembaruanTerakhir;
  final List<SofParkirResultEntity> data;

  const CardRekapJenisPembayaranWidget({
    super.key,
    required this.data,
    this.isShowPembaruanTerakhir = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ), // Border halus khas Government
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ), // Shadow dipertipis agar lebih elegan
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Rekap Metode Pembayaran",
                  style: AppTypography.bodySemiBold,
                ),
              ),
              if (isShowPembaruanTerakhir)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Pembaruan Terakhir",
                      style: AppTypography.caption.copyWith(
                        color: Colors.grey.shade500,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(DateTime.now()),
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (_, __) =>
                Divider(height: 24, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final item = data[index];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                Colors.orange.shade400, // Aksen warna Bapenda
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.sof,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: _ItemKendaraanBadge(
                      total: item.nominalMotor,
                      jumlahKendaraan: item.jumlahMotor,
                      icon: Icons.two_wheeler,
                      accentColor: Colors.teal.shade600,
                    ),
                  ),

                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: _ItemKendaraanBadge(
                      total: item.nominalMobil,
                      jumlahKendaraan: item.jumlahMobil,
                      icon: Icons.directions_car,
                      accentColor: Colors.blue.shade700,
                    ),
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

class _ItemKendaraanBadge extends StatelessWidget {
  final double total;
  final int jumlahKendaraan;
  final IconData icon;
  final Color accentColor;

  const _ItemKendaraanBadge({
    required this.total,
    required this.jumlahKendaraan,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isZero = total == 0 && jumlahKendaraan == 0;

    final Color displayColor = isZero ? Colors.grey.shade400 : accentColor;
    final Color bgColor = isZero
        ? Colors.grey.shade50
        : accentColor.withValues(alpha: 0.05);
    final Color borderColor = isZero
        ? Colors.grey.shade200
        : accentColor.withValues(alpha: 0.2);
    final Color textColor = isZero ? Colors.grey.shade500 : Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            CurrencyFormatter.toIdr(total),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                NumberFormatter.format(jumlahKendaraan),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: displayColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 14, color: displayColor),
            ],
          ),
        ],
      ),
    );
  }
}
