import 'package:flutter/material.dart';
import '../widgets/filter_header_widget.dart';
import '../widgets/total_summary_card.dart';
import '../widgets/bulan_item_card.dart';
import '../widgets/footer_total_card.dart';

class DetailRealisasiOpPage extends StatelessWidget {
  const DetailRealisasiOpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Realisasi pembayaran',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // 🚀 1. Header Filter Terpisah
          FilterHeaderWidget(
            canIncrement: true,
            selectedYear: 2025,
            onDecrementYear: () => print('Hit API Tahun Sebelumnya'),
            onIncrementYear: () => print('Hit API Tahun Depan'),
            onTapTahun: () => print('Munculkan Bottom Sheet'),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // 🚀 2. Summary Atas
                  const TotalSummaryCard(
                    tahun: '2025',
                    totalNominal: 'Rp 9.090.000',
                  ),
                  const SizedBox(height: 16),

                  // 🚀 3. List Item Bersih (Kelak dibungkus ListView.builder)
                  const BulanItemCard(
                    bulan: 'Januari',
                    sspd: 'SSPD 04 Feb 2025',
                    nominal: 'Rp 860.000',
                  ),
                  const SizedBox(height: 8),
                  const BulanItemCard(
                    bulan: 'Februari',
                    sspd: 'SSPD 03 Mar 2025',
                    nominal: 'Rp 800.000',
                  ),
                  const SizedBox(height: 8),
                  const BulanItemCard(
                    bulan: 'Maret',
                    sspd: 'SSPD 08 Apr 2025',
                    nominal: 'Rp 750.000',
                  ),
                  const SizedBox(height: 8),
                  const BulanItemCard(
                    bulan: 'April',
                    sspd: 'SSPD 08 Mei 2025',
                    nominal: 'Rp 970.000',
                  ),

                  const SizedBox(height: 16),

                  // 🚀 4. Footer Total
                  const FooterTotalCard(
                    tahun: '2025',
                    totalNominal: 'Rp 9.090.000',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
