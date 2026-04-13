// lib/features/transaction/widgets/botsheet_tarif_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../home/data/models/tarif_model.dart';

class BottomSheetTarifParkir extends StatelessWidget {
  final List<TarifModel> tarifList; // 🚀 Menggunakan Model!
  final bool isFree;
  final Function(TarifModel) onTap;

  const BottomSheetTarifParkir({
    super.key,
    required this.tarifList,
    required this.isFree,
    required this.onTap,
  });

  /// static method untuk memanggil bottomsheet
  static void show(
    BuildContext context, {
    required List<TarifModel> tarifList,
    required bool isFree,
    required Function(TarifModel) onTap,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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

          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: tarifList.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: AppColors.border),
              itemBuilder: (context, index) {
                final item =
                    tarifList[index]; // 🚀 item sekarang adalah TarifModel

                return ListTile(
                  contentPadding: EdgeInsets.zero,
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
                    onTap(item); // 🚀 Langsung lempar modelnya
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
