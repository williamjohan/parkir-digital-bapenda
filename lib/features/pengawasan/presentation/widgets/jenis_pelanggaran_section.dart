import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/dropdown/pb_dropdown.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_basic_bottom_sheet.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/domain/entities/jenis_pelanggaran/jenis_pelanggaran_entity.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/presentation/widgets/laporan_section_card.dart';

class JenisPelanggaranSection extends StatelessWidget {
  final List<JenisPelanggaranEntity> jenisPelanggaranList;
  final int? selectedJenisPelId;
  final ValueChanged<int> onJenisPelanggaranSelected;

  const JenisPelanggaranSection({
    super.key,
    required this.jenisPelanggaranList,
    required this.selectedJenisPelId,
    required this.onJenisPelanggaranSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Mencari item yang sedang dipilih berdasarkan id
    final selectedValue = jenisPelanggaranList
        .where((e) => e.id == selectedJenisPelId)
        .firstOrNull;

    return LaporanSectionCard(
      title: 'Jenis Pelanggaran',
      icon: Icons.report_problem_outlined,
      child: PbDropdown<JenisPelanggaranEntity>(
        hintText: 'Pilih jenis pelanggaran',
        value: selectedValue,
        itemLabel: (item) => item.nama,
        onTap: () {
          PbBasicBottomSheet.show(
            context: context,
            title: 'Pilih Jenis Pelanggaran',
            child: SizedBox(
              height: 350,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16),
                itemCount: jenisPelanggaranList.length,
                itemBuilder: (_, index) {
                  final item = jenisPelanggaranList[index];
                  final isSelected = item.id == selectedJenisPelId;

                  return GestureDetector(
                    onTap: () {
                      onJenisPelanggaranSelected(item.id);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.disabled,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.nama,
                              style: AppTypography.caption.copyWith(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.disabled,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked_outlined
                                : Icons.radio_button_off_outlined,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.disabled,
                          ),
                        ],
                      ),
                    ),
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
