import 'package:flutter/material.dart';
import '../../../core/design_system/tokens/app_colors.dart';
import '../../../core/design_system/tokens/app_typography.dart';
import 'botsheet_tarif_widget.dart';

class CardJenisKendaraan extends StatefulWidget {
  final List<Map<String, dynamic>> tarifList;

  /// 🔥 kirim 2 parameter
  final Function(String jenisTarif, int tarif)? onSelected;

  const CardJenisKendaraan({
    super.key,
    this.onSelected,
    required this.tarifList,
  });

  @override
  State<CardJenisKendaraan> createState() => _CardJenisKendaraanState();
}

class _CardJenisKendaraanState extends State<CardJenisKendaraan> {
  String? selectedJenisTarif;
  int? selectedTarif;

  final TextEditingController tarifController = TextEditingController();

  void _onSelect(Map<String, dynamic> selected) {
    setState(() {
      selectedJenisTarif = selected['jenisTarif'];
      selectedTarif = selected['tarif'];
      tarifController.text = "Rp$selectedTarif";
    });

    /// 🔥 kirim 2 data langsung
    if (widget.onSelected != null) {
      widget.onSelected!(selectedJenisTarif!, selectedTarif!);
    }
  }

  @override
  void dispose() {
    tarifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "JENIS KENDARAAN",
            style: AppTypography.heading6.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          /// 🔥 Dropdown Button
          InkWell(
            onTap: () {
              BottomSheetTarifParkir.show(
                context,
                tarifList: widget.tarifList,
                onTap: (selected) {
                  _onSelect(selected);
                },
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedJenisTarif ?? "Pilih Jenis Kendaraan",
                    style: AppTypography.bodyText.copyWith(
                      color: selectedJenisTarif == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 🔥 Tarif Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tarif Parkir", style: AppTypography.caption),
              const SizedBox(height: 4),

              TextField(
                controller: tarifController,
                style: AppTypography.bodyRegular,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Rp0",
                  hintStyle: AppTypography.bodyText.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.border),
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
