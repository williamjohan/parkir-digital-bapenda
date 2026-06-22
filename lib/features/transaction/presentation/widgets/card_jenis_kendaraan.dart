import 'package:flutter/material.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../home/data/models/tarif_model.dart';

class CardJenisKendaraan extends StatelessWidget {
  final List<TarifModel> tarifList;
  final TarifModel? selectedTarif;
  final bool isFree;
  final Function(TarifModel) onSelected;
  final String op;
  final String alamat;

  const CardJenisKendaraan({
    super.key,
    required this.tarifList,
    required this.selectedTarif,
    required this.isFree,
    required this.onSelected,
    required this.op,
    required this.alamat,
  });

  // Icon kendaraan berdasarkan label
  IconData _iconFor(String jenis) {
    final j = jenis.toLowerCase();
    if (j.contains('motor')) return Icons.two_wheeler_rounded;
    if (j.contains('mobil')) return Icons.directions_car_rounded;
    if (j.contains('bus')) return Icons.directions_bus_rounded;
    if (j.contains('truk') || j.contains('truck')) {
      return Icons.local_shipping_rounded;
    }
    return Icons.commute_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      op,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.heading5.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      alamat,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(9),
                  ),
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.commute_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
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
                    Text(
                      '*',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Grid Pilihan ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: tarifList.isEmpty
                    ? _EmptyVehicleState()
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tarifList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.9,
                            ),
                        itemBuilder: (context, index) {
                          final tarif = tarifList[index];
                          final isSelected = selectedTarif?.id == tarif.id;

                          return _VehicleChip(
                            tarif: tarif,
                            isSelected: isSelected,
                            icon: _iconFor(tarif.jenisTarif),
                            onTap: () => onSelected(tarif),
                          );
                        },
                      ),
              ),

              // ── Selected Indicator ───────────────────────────────────────────
              if (selectedTarif != null) ...[
                Divider(height: 1, color: AppColors.border),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Dipilih: ',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        selectedTarif!.jenisTarif,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ─── CHIP KENDARAAN ───────────────────────────────────────────────────────────

class _VehicleChip extends StatelessWidget {
  final TarifModel tarif;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const _VehicleChip({
    required this.tarif,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          // boxShadow: isSelected
          //     ? [
          //         BoxShadow(
          //           color: AppColors.primary.withValues(alpha: 0.25),
          //           blurRadius: 8,
          //           offset: const Offset(0, 3),
          //         ),
          //       ]
          //     : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: isSelected
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.2),
              radius: 40,
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tarif.jenisTarif,
              style: AppTypography.heading4.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              tarif.jenisTarif == "Mobil" ? "Roda 4" : "Roda 2",
              style: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── EMPTY STATE ──────────────────────────────────────────────────────────────

class _EmptyVehicleState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.sync_problem_rounded, size: 36, color: AppColors.border),
            const SizedBox(height: 8),
            Text(
              'Data kendaraan belum tersedia',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Hubungi administrator untuk sinkronisasi',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
