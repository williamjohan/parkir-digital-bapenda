import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../data/jadwal_dummy_model.dart';
import '../widget/jadwal_card_item.dart';

class JadwalScreen extends StatelessWidget {
  const JadwalScreen({super.key});

  // Dummy Data 1 Minggu
  List<JadwalDummyModel> get _generateDummyData {
    final now = DateTime.now();
    return [
      JadwalDummyModel(
        tanggal: now.subtract(const Duration(days: 2)),
        hari: 'Senin',
        checkIn: '05:50',
        checkOut: '14:05',
      ),
      JadwalDummyModel(
        tanggal: now.subtract(const Duration(days: 1)),
        hari: 'Selasa',
        checkIn: '06:10', // Terlambat
        checkOut: '14:00',
      ),
      JadwalDummyModel(
        tanggal: now,
        hari: 'Rabu',
        checkIn: '05:55',
        checkOut: '--:--', // Belum checkout
      ),
      JadwalDummyModel(
        tanggal: now.add(const Duration(days: 1)),
        hari: 'Kamis',
      ),
      JadwalDummyModel(
        tanggal: now.add(const Duration(days: 2)),
        hari: 'Jumat',
      ),
      JadwalDummyModel(
        tanggal: now.add(const Duration(days: 3)),
        hari: 'Sabtu',
        isLibur: true,
        keteranganLibur: '-',
      ),
      JadwalDummyModel(
        tanggal: now.add(const Duration(days: 4)),
        hari: 'Minggu',
        isLibur: true,
        keteranganLibur: '-',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final jadwalList = _generateDummyData;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Jadwal & Kehadiran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: jadwalList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final jadwal = jadwalList[index];
          return JadwalCardItem(jadwal: jadwal);
        },
      ),
    );
  }
}
