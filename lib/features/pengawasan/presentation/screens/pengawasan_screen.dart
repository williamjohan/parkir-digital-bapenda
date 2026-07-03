import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/routes/app_routes.dart';
import '../../domain/constants/jenis_pelanggaran_dummy.dart';
import '../cubit/pengawasan_cubit.dart';
import '../cubit/pengawasan_state.dart';
import '../widgets/card_laporan_pelanggaran.dart';

class LaporanPelanggaranScreen extends StatefulWidget {
  const LaporanPelanggaranScreen({super.key});

  @override
  State<LaporanPelanggaranScreen> createState() =>
      _LaporanPelanggaranScreenState();
}

class _LaporanPelanggaranScreenState extends State<LaporanPelanggaranScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PengawasanCubit>().getLaporanPengawasan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Laporan Pelanggaran', style: AppTypography.heading5),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<PengawasanCubit, PengawasanState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          final items = state.isLoadingLaporan
              ? state.laporanFake
              : state.laporan;

          if (state.laporan.isEmpty && !state.isLoadingLaporan) {
            return const Center(child: Text('Belum ada laporan.'));
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<PengawasanCubit>().getLaporanPengawasan(),
            child: Skeletonizer(
              enabled: state.isLoadingLaporan,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final laporan = items[index];

                  return CardLaporanPelanggaran(
                    item: laporan,
                    onTapLaporan: () {
                      final jenisPelanggaran = dummyJenisPelanggaran.firstWhere(
                        (e) => e.id == laporan.jenisPel,
                      );
                      context.pushNamed(
                        AppRoutes.detailLaporanPelanggaran,
                        extra: {
                          'namaJenisPelanggaran': jenisPelanggaran.nama,
                          'keterangan': laporan.ketPel,
                          'foto': laporan.fotoPelaporan,
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
