import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/dashboard_summary_non_jukir_entity.dart';

class CardRekapJenisPembayaranWidget extends StatelessWidget {
  final List<SofParkirResultEntity> data;

  const CardRekapJenisPembayaranWidget({super.key, required this.data});

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
          // === HEADER KARTU ===
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

              // 🚀 EXPANDED: Mendorong tanggal ke ujung kanan & mencegah teks judul tumpah
              const Expanded(
                child: Text(
                  "Rekap Metode Pembayaran",
                  style: AppTypography.bodySemiBold,
                ),
              ),

              // 🚀 WIDGET SYSDATE DI KANAN
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
                        // Format: 19 Jun 2026, 14:45
                        DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
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

          // === LIST DATA ===
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
                  // 1. NAMA METODE PEMBAYARAN (SOF)
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

                  // 2. BADGE STATISTIK MOTOR
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

                  // 3. BADGE STATISTIK MOBIL
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

// === WIDGET ANAK KHUSUS (THE BADGE) ===
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
    // Cek apakah transaksinya 0. Jika 0, kita redupkan warnanya agar mata fokus ke data yang aktif.
    final bool isZero = total == 0 && jumlahKendaraan == 0;

    final Color displayColor = isZero ? Colors.grey.shade400 : accentColor;
    final Color bgColor = isZero
        ? Colors.grey.shade50
        : accentColor.withValues(alpha: 0.05);
    final Color borderColor = isZero
        ? Colors.grey.shade200
        : accentColor.withValues(alpha: 0.2);
    final Color textColor = isZero ? Colors.grey.shade500 : Colors.black87;

    // Formatter Rupiah Cantik (Menghilangkan .0 di belakang)
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

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
          // Nominal Uang
          Text(
            formatCurrency.format(total),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Jumlah & Ikon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                jumlahKendaraan.toString(),
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
