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
        title: Text(
          'Laporan Pelanggaran',
          style: AppTypography.heading5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        shape: Border(bottom: BorderSide(color: AppColors.primary, width: 1.0)),
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: AppColors.primary),
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
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        size: 48,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Belum ada laporan",
                      style: AppTypography.bodySemiBold.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Laporan yang kamu buat akan muncul di sini",
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            );
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
