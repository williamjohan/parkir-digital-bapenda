import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/domain/entities/data_jukir_entity.dart';

class CardDataJukir extends StatelessWidget {
  final List<DataJukirEntity> dataJukirList;
  final DataJukirEntity? selectedJukir;
  final ValueChanged<DataJukirEntity> onSelected;

  const CardDataJukir({
    super.key,
    required this.dataJukirList,
    required this.selectedJukir,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  Icons.people_alt_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'DAFTAR JUKIR',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
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
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${dataJukirList.length}',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (dataJukirList.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Belum ada data jukir',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ListView.separated(
              padding: const EdgeInsets.all(12),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataJukirList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final jukir = dataJukirList[index];

                final isSelected = selectedJukir?.username == jukir.username;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onSelected(jukir),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.15,
                          ),
                          child: Icon(Icons.person, color: AppColors.primary),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jukir.namaPetugas,
                                style: AppTypography.bodySemiBold.copyWith(
                                  color: isSelected ? AppColors.primary : null,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  const Icon(Icons.badge_outlined, size: 14),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      jukir.username,
                                      style: AppTypography.bodySmall,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone_android_outlined,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      jukir.deviceId,
                                      style: AppTypography.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  key: ValueKey('selected'),
                                  color: AppColors.primary,
                                )
                              : const Icon(
                                  Icons.radio_button_unchecked,
                                  key: ValueKey('unselected'),
                                  color: Colors.grey,
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
