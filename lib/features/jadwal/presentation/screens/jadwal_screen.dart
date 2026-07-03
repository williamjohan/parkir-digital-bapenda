import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../cubit/jadwal_cubit.dart';
import '../cubit/jadwal_state.dart';
import '../widget/jadwal_card_item.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  @override
  void initState() {
    super.initState();
    context.read<JadwalCubit>().fetchJadwal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Jadwal & Kehadiran ',
          style: AppTypography.heading5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        scrolledUnderElevation:
            0, // 🚀 Wajib di M3 agar warna tidak berubah saat scroll
        // 🚀 BEST PRACTICE 1: Gunakan shape dengan Border.bottom
        shape: Border(
          bottom: BorderSide(
            color:
                AppColors.primary, // Gunakan warna border soft (abu-abu tipis)
            width: 1.0, // Ketebalan 1px sudah cukup untuk kesan elegan
          ),
        ),
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      body: const JadwalContentView(),
    );
  }
}

// ==========================================
// 2. WIDGET ANAK (VIEW / CONTENT)
// Bertugas membaca BLoC dan merender list atau error
// ==========================================
class JadwalContentView extends StatelessWidget {
  const JadwalContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await context.read<JadwalCubit>().fetchJadwal(forceRefresh: true);
      },
      child: BlocBuilder<JadwalCubit, JadwalState>(
        builder: (context, state) {
          switch (state.status) {
            case JadwalStatus.initial:
            case JadwalStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );

            case JadwalStatus.failure:
              return _buildErrorState(context, state.message);

            case JadwalStatus.success:
              final jadwalList = state.jadwal ?? [];

              if (jadwalList.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                itemCount: jadwalList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  // Render per item menggunakan Card yang sudah kita buat
                  return JadwalCardItem(jadwal: jadwalList[index]);
                },
              );
          }
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        const Icon(Icons.cloud_off, size: 64, color: AppColors.disabled),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            onPressed: () => context.read<JadwalCubit>().fetchJadwal(),
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        const Icon(Icons.event_note, size: 64, color: AppColors.disabled),
        const SizedBox(height: 16),
        const Text(
          'Jadwal belum tersedia.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
      ],
    );
  }
}
