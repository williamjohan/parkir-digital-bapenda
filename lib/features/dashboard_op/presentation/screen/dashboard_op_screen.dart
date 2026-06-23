import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/presentation/widgets/header_dashboard_op_widget.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../widgets/card_rekap_jenis_pembayaran_op.dart';
import '../widgets/card_realisasi_op.dart';
import '../widgets/card_riwayat_pendapatan.dart';

class DashboardOpScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const DashboardOpScreen({super.key, required this.item});

  @override
  State<DashboardOpScreen> createState() => _DashboardOpScreenState();
}

class _DashboardOpScreenState extends State<DashboardOpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Detail Objek Pajak', style: AppTypography.heading5),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderDashboardOp(
              item: widget.item,
              totalPendapatan: 66000,
              pajakPercent: 10,
              pendapatanBersih: 59400,
              isDigital: true,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CardRiwayatPendapatanOp(
                        totalMotor: 8,
                        totalMobil: 10,
                        onLihatSemua: () {},
                        riwayat: const [
                          RiwayatPendapatanItem(
                            jenisKendaraan: 'Mobil',
                            tanggal: '20 Jun 10:06',
                            nominal: 5000,
                          ),
                          RiwayatPendapatanItem(
                            jenisKendaraan: 'Motor',
                            tanggal: '19 Jun 18:19',
                            nominal: 2000,
                          ),
                          RiwayatPendapatanItem(
                            jenisKendaraan: 'Mobil',
                            tanggal: '18 Jun 14:22',
                            nominal: 5000,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      CardRealisasiOp(
                        nonDigital: 3005000,
                        digital: 734100,
                        totalRealisasi: 3739100,
                        tahun: '2026',
                        onLihatSemua: () {},
                      ),
                      SizedBox(height: 16),
                      CardRekapJenisPembayaranOp(
                        items: const [
                          RekapJenisPembayaranItem(
                            nama: 'BRIZZI',
                            motorNominal: 721000,
                            motorJumlah: 181,
                            mobilNominal: 158000,
                            mobilJumlah: 22,
                          ),
                          RekapJenisPembayaranItem(
                            nama: 'E-MONEY',
                            motorNominal: 130000,
                            motorJumlah: 52,
                            mobilNominal: 460000,
                            mobilJumlah: 55,
                          ),
                          RekapJenisPembayaranItem(
                            nama: 'QRIS SCAN',
                            motorNominal: 371000,
                            motorJumlah: 101,
                            mobilNominal: 345000,
                            mobilJumlah: 55,
                          ),
                        ],
                        onLihatSemua: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
