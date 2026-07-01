import 'package:flutter/material.dart';

import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../dashboard_op/data_jukir/domain/entities/data_jukir_entity.dart';
import '../../../dashboard_op/data_jukir/presentation/widgets/data_jukir_card.dart';
import '../../../dashboard_op/data_jukir/presentation/widgets/pendapatan_info_card.dart';

class DataJukirScreen2 extends StatelessWidget {
  const DataJukirScreen2({super.key});

  List<DataJukirEntity> get dummyData => [
    DataJukirEntity(
      idDevice: "DV001",
      petugas: "Ahmad Fauzi",
      shift: "Pagi",
      totalMobilHariIni: 18,
      totalMotorHariIni: 95,
      totalNominalMobilHariIni: 900000,
      totalNominalMotorHariIni: 285000,
      totalKendaraan: 113,
      totalNominal: 1185000,
      usernameList: const [
        UsernameEntity(username: "ahmad01", namaPetugas: "Ahmad Fauzi"),
      ],
    ),
    DataJukirEntity(
      idDevice: "DV002",
      petugas: "Budi Santoso",
      shift: "Siang",
      totalMobilHariIni: 21,
      totalMotorHariIni: 81,
      totalNominalMobilHariIni: 1050000,
      totalNominalMotorHariIni: 243000,
      totalKendaraan: 102,
      totalNominal: 1293000,
      usernameList: const [
        UsernameEntity(username: "budi02", namaPetugas: "Budi Santoso"),
      ],
    ),
    DataJukirEntity(
      idDevice: "DV003",
      petugas: "Rizky",
      shift: "Malam",
      totalMobilHariIni: 12,
      totalMotorHariIni: 63,
      totalNominalMobilHariIni: 600000,
      totalNominalMotorHariIni: 189000,
      totalKendaraan: 75,
      totalNominal: 789000,
      usernameList: const [
        UsernameEntity(username: "rizky03", namaPetugas: "Rizky"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("Daftar Jukir", style: AppTypography.heading5),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: PendapatanInfoCard(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: dummyData.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return DataJukirCard(
                    entity: dummyData[index],
                    lihatRiwayatOnTap: () {
                      // TODO: Navigate ke riwayat
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
