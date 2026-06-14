// lib/features/transaction/widgets/botsheet_tarif_widget.dart

import 'package:flutter/material.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../home/data/models/tarif_model.dart';

class BottomSheetTarifParkir extends StatelessWidget {
  final List<TarifModel> tarifList;
  final bool isFree;
  final Function(TarifModel) onTap;

  const BottomSheetTarifParkir({
    super.key,
    required this.tarifList,
    required this.isFree,
    required this.onTap,
  });

  static void show(
    BuildContext context, {
    required List<TarifModel> tarifList,
    required bool isFree,
    required Function(TarifModel) onTap,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BottomSheetTarifParkir(
          tarifList: tarifList,
          isFree: isFree,
          onTap: onTap,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24,
      ), // 🚀 UX: Padding bawah lebih besar untuk area aman (Safe Area)
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Handle Bar ---
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Text("Pilih Tarif Parkir", style: AppTypography.heading5),
          const SizedBox(height: 16),

          // --- Scrollable List ---
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.4, // Maksimal 40% dari tinggi layar
            ),
            // 🚀 UX FIX 1: Bungkus ListView dengan Scrollbar
            child: Scrollbar(
              radius: const Radius.circular(8),
              thickness: 4,
              child: ListView.separated(
                shrinkWrap: true,
                // 🚀 UX FIX 2: Bouncing effect agar list terasa interaktif/hidup
                physics: const BouncingScrollPhysics(),
                itemCount: tarifList.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: AppColors.border),
                itemBuilder: (context, index) {
                  final item = tarifList[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ), // Sedikit padding agar text tidak menempel ke garis pinggir
                    title: Text(
                      item.jenisTarif,
                      style: AppTypography.bodySemiBold,
                    ),
                    subtitle: Text(
                      isFree ? "Rp0 (GRATIS)" : "Rp ${item.tarif.toInt()}",
                      style: AppTypography.caption.copyWith(
                        color: isFree ? Colors.green : AppColors.textSecondary,
                      ),
                    ),
                    onTap: () {
                      onTap(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
