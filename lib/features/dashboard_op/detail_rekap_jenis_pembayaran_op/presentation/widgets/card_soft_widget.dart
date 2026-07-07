import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import '../../../dashboard_main/domain/entities/dashboard_op_entity.dart';
import 'item_nominal_sof_widget.dart';

class CardSofWidget extends StatelessWidget {
  final SofEntity item;

  const CardSofWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.sof.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ItemNominalSofWidget(
                    isMotor: true,
                    nominal: item.nominalMotor,
                    jumlah: item.jumlahMotor,
                    borderColor: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ItemNominalSofWidget(
                    isMotor: false,
                    nominal: item.nominalMobil,
                    jumlah: item.jumlahMobil,
                    borderColor: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
