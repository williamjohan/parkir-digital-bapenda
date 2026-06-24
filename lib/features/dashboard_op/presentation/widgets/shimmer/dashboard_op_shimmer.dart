import 'package:flutter/material.dart';

import 'card_jenis_pembayaran_shimmer.dart';
import 'card_realisasi_shimmer.dart';
import 'card_riwayat_pendapatan_shimmer.dart';
import 'header_dashboard_shimmer.dart';

class DashboardOpShimmer extends StatelessWidget {
  const DashboardOpShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HeaderDashboardOpShimmer(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                CardRiwayatPendapatanShimmer(),
                SizedBox(height: 16),

                CardRealisasiShimmer(),
                SizedBox(height: 16),

                CardJenisPembayaranShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
