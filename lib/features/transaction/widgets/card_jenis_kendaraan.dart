// lib/features/transaction/widgets/card_jenis_kendaraan.dart

import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../core/design_system/components/pb_primary_button.dart';
import '../../home/data/models/tarif_model.dart';

// 🚀 [ENHANCE]: Menjadi StatelessWidget (Dumb Widget)
class CardJenisKendaraan extends StatelessWidget {
  final List<TarifModel> tarifList;
  final TarifModel? selectedTarif;
  final bool isFree;
  final Function(TarifModel) onSelected;

  const CardJenisKendaraan({
    super.key,
    required this.tarifList,
    required this.selectedTarif,
    required this.isFree,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Penentuan teks dinamis
    // final displayJenis = selectedTarif?.jenisTarif ?? "Pilih Jenis Kendaraan";
    final displayTarif = selectedTarif != null
        ? (isFree ? "Rp0 (GRATIS)" : "Rp${selectedTarif!.tarif.toInt()}")
        : "Rp0";

    // untuk testing
    // final List<TarifModel> dummyTarifList = [
    //   const TarifModel(id: 1, jenisTarif: "Motor", tarif: 2000),
    //   const TarifModel(id: 2, jenisTarif: "Mobil", tarif: 5000),
    //   const TarifModel(id: 3, jenisTarif: "Bus", tarif: 10000),
    //   const TarifModel(id: 4, jenisTarif: "Truk", tarif: 15000),
    // ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "JENIS KENDARAAN",
                style: AppTypography.heading6.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(width: 2),
              Text("*", style: TextStyle(color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 16),

          /// Grid Jenis Kendaraan
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tarifList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 🚀 max 3 per baris
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.5, // biar tombol tidak terlalu tinggi
            ),
            itemBuilder: (context, index) {
              final tarif = tarifList[index];
              final isSelected = selectedTarif?.id == tarif.id;

              return PbPrimaryButton(
                text: tarif.jenisTarif,
                onPressed: () => onSelected(tarif),
                variant: isSelected
                    ? PbButtonVariant.outlinedPrimary
                    : PbButtonVariant.outlinedSecondaryDark,
              );
            },
          ),

          const SizedBox(height: 16),

          /// Tarif Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tarif Parkir", style: AppTypography.caption),
              const SizedBox(height: 4),

              TextField(
                controller: TextEditingController(
                  text: displayTarif,
                ), // 🚀 Dikontrol sepenuhnya dari atas
                style: AppTypography.bodyRegular.copyWith(
                  color: isFree ? Colors.green : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
