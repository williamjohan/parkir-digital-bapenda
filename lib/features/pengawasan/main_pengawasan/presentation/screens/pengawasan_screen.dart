import 'package:flutter/material.dart';

import '../../../../../core/design_system/tokens/app_colors.dart';
import '../widgets/card_rekap_laporan.dart';

class LaporanPelanggaranScreen extends StatelessWidget {
  const LaporanPelanggaranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan Pelanggaran"),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyLaporan.length,
        itemBuilder: (_, index) {
          return CardLaporanPelanggaran(item: dummyLaporan[index]);
        },
      ),
    );
  }
}
