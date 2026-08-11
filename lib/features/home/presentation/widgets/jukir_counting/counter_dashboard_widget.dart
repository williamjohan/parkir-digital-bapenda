import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_status_snackbar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../cubit/counter_kendaraan/jukir_counter_cubit.dart';
import '../../cubit/counter_kendaraan/jukir_counter_state.dart';


class CounterDashboardWidget extends StatefulWidget {
  final String namaOp;
  final String alamatOp;

  const CounterDashboardWidget({
    super.key,
    required this.namaOp,
    required this.alamatOp,
  });

  @override
  State<CounterDashboardWidget> createState() => _CounterDashboardWidgetState();
}

class _CounterDashboardWidgetState extends State<CounterDashboardWidget> {
  // Hanya menyimpan status pilihan UI secara lokal
  String? _selectedJenis; 

  void _onSubmit() {
    if (_selectedJenis == null) return;
    
    context.read<JukirCounterCubit>().submitCounter(_selectedJenis!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JukirCounterCubit, JukirCounterState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == JukirCounterStatus.submitSuccess) {
          PbStatusSnackbar.show(context, message: 'Berhasil mencatat 1 $_selectedJenis' );
          // Opsional: Kosongkan pilihan setelah berhasil
          // setState(() => _selectedJenis = null);
        } else if (state.status == JukirCounterStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Gagal mencatat kendaraan'),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            )
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == JukirCounterStatus.submitting;
        final isFetching = state.status == JukirCounterStatus.loading || 
                       state.status == JukirCounterStatus.initial;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // BUNGKUS KONTEN ATAS DENGAN EXPANDED & SCROLLVIEW
             Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    await context.read<JukirCounterCubit>().fetchInitialCounter();
                  },
                  child: SingleChildScrollView(
                    // 🚀 WAJIB PAKAI INI agar bisa ditarik walau konten tidak penuh
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        
                        // 2. PILIHAN KENDARAAN
                        _buildKendaraanSelection(isSubmitting),
                        
                        const SizedBox(height: 16),
                        
                        // 3. RINGKASAN TOTAL HARI INI
                        _buildSummaryCard(state.mobilCount, state.motorCount, isFetching),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              
              // 4. TOMBOL SUBMIT STICKY BOTTOM
              PbPrimaryButton(
                text: isSubmitting ? 'Mengirim Data...' : 'Catat Kendaraan Masuk',
                // Disable tombol jika tidak ada pilihan ATAU sedang proses API
                onPressed: (_selectedJenis != null && !isSubmitting) 
                    ? _onSubmit 
                    : null,
              ),
              
              const SizedBox(height: 16), 
            ],
          ),
        );
      },
    );
  }

 
 Widget _buildKendaraanSelection(bool isSubmitting) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Label
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
              border: const Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(Icons.commute_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'JENIS KENDARAAN',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('*', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          // Grid Pilihan Kendaraan
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _VehicleSelectChip(
                    title: 'Mobil',
                    subtitle: 'Roda 4',
                    icon: Icons.directions_car_rounded,
                    isSelected: _selectedJenis == 'Mobil',
                    // Cegah klik pindah jenis jika sedang proses hit API
                    onTap: isSubmitting 
                        ? () {} 
                        : () => setState(() => _selectedJenis = 'Mobil'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _VehicleSelectChip(
                    title: 'Motor',
                    subtitle: 'Roda 2',
                    icon: Icons.two_wheeler_rounded,
                    isSelected: _selectedJenis == 'Motor',
                    onTap: isSubmitting 
                        ? () {} 
                        : () => setState(() => _selectedJenis = 'Motor'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _buildSummaryCard(int mobilCount, int motorCount, bool isFetching) {
    return Skeletonizer(
      enabled: isFetching,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryItem(title: 'Total Mobil', count: mobilCount, icon: Icons.directions_car),
            Container(width: 1, height: 40, color: AppColors.border),
            _SummaryItem(title: 'Total Motor', count: motorCount, icon: Icons.two_wheeler),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET PENDUKUNG ---

class _VehicleSelectChip extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleSelectChip({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: isSelected
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.2),
              radius: 40,
              child: Icon(icon, size: 28, color: isSelected ? Colors.white : AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTypography.heading4.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const _SummaryItem({required this.title, required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(title, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: AppTypography.heading3.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}