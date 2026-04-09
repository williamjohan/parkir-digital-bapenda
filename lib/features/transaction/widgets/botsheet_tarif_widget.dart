import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class BottomSheetTarifParkir extends StatelessWidget {
  final List<Map<String, dynamic>> tarifList;
  final Function(Map<String, dynamic>) onTap;

  const BottomSheetTarifParkir({
    super.key,
    required this.tarifList,
    required this.onTap,
  });

  /// 🔥 static method untuk memanggil bottomsheet
  static void show(
    BuildContext context, {
    required List<Map<String, dynamic>> tarifList,
    required Function(Map<String, dynamic>) onTap,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BottomSheetTarifParkir(tarifList: tarifList, onTap: onTap);
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
          // handle
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
              separatorBuilder: (_, __) => Divider(color: AppColors.border),
              itemBuilder: (context, index) {
                final item = tarifList[index];

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item['jenisTarif'] ?? '',
                    style: AppTypography.bodySemiBold,
                  ),
                  subtitle: Text(
                    "Rp ${item['tarif']}",
                    style: AppTypography.caption,
                  ),
                  onTap: () {
                    onTap(item);
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
