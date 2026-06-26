import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/chip_indicator/pb_chip_indicator.dart';
import '../../../../core/design_system/components/chip_indicator/pb_chip_type.dart';
import '../../../../core/design_system/components/chip_indicator/pb_radius_type.dart';
import '../../../../core/design_system/components/pb_text_field.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/routes/app_routes.dart';
import '../cubit/search_op/search_op_cubit.dart';
import '../cubit/search_op/search_op_state.dart';
import '../widgets/search_op_widget.dart';

class SearchOpPage extends StatefulWidget {
  final RoleLoginDigitalParkir role;
  final SearchOpType? opType;

  const SearchOpPage({super.key, required this.role, this.opType});

  @override
  State<SearchOpPage> createState() => _SearchOpPageState();
}

class _SearchOpPageState extends State<SearchOpPage> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  int selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    if (widget.opType != null) {
      context.read<SearchOpCubit>().getNopListByKategori(type: widget.opType!);
    } else {
      context.read<SearchOpCubit>().getNopList();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel(); // 🚀 Bersihkan memory timer saat halaman ditutup
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<SearchOpCubit>().searchNopAlamat(value);
    });
  }

  void _onFilterChanged(int index) {
    setState(() {
      selectedFilter = index;
    });

    searchController.clear();

    final cubit = context.read<SearchOpCubit>();

    switch (index) {
      case 0:
        cubit.getNopList();
        break;

      case 1:
        cubit.getNopListByKategori(type: SearchOpType.digital);
        break;

      case 2:
        cubit.getNopListByKategori(type: SearchOpType.nonDigital);
        break;

      case 3:
        cubit.getNopListByKategori(type: SearchOpType.free);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Objek Pajak', style: AppTypography.heading5),
          centerTitle: true,
          backgroundColor: AppColors.surface,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
          child: Column(
            children: [
              PbTextField(
                controller: searchController,
                hintText: 'Cari berdasarkan nama / alamat ...',
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 12),

              SearchOpFilterWidget(
                selectedIndex: selectedFilter,
                onChanged: _onFilterChanged,
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<SearchOpCubit, SearchOpState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.filteredNopList.isEmpty) {
                      return const Center(child: Text('Data tidak ditemukan'));
                    }

                    return ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: state.filteredNopList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = state.filteredNopList[index];

                        final isDigital = (item['is_digital'] ?? 0) == 1;
                        final isFree = (item['pungut_tarif'] ?? 0) == 1;
                        final chipType = isFree
                            ? getTarifType(item)
                            : getDigitalType(item);
                        //     item['is_digital'] == false &&
                        //     item['pungut_tarif'] == 2;

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.pushNamed(
                              AppRoutes.dashboardObjekPajak,
                              extra: {'item': item},
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 4,
                                    decoration: BoxDecoration(
                                      color: chipType.foregroundColor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 8,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary
                                                        .withValues(
                                                          alpha: 0.08,
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                    border: Border.all(
                                                      color: AppColors.primary
                                                          .withValues(
                                                            alpha: 0.15,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "UPTB ${item['uptb'] ?? '-'}",
                                                    style: AppTypography.caption
                                                        .copyWith(
                                                          color:
                                                              AppColors.primary,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: item['nama_op'] ?? '-',
                                                style: AppTypography
                                                    .bodySemiBold
                                                    .copyWith(
                                                      color:
                                                          AppColors.textPrimary,
                                                      fontSize: 15,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 4,
                                          children: [
                                            if (isDigital || !isFree)
                                              PbChipIndicator(
                                                labelText: getDigitalLabel(
                                                  item,
                                                ),
                                                type: getDigitalType(item),
                                                radius: PbRadiusType.full,
                                              ),
                                            // disini
                                            if (isFree)
                                              PbChipIndicator(
                                                labelText: getTarifLabel(item),
                                                type: getTarifType(item),
                                                radius: PbRadiusType.full,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),

                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .confirmation_number_outlined,
                                              size: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                item['nop'] ?? '-',
                                                style: AppTypography.caption
                                                    .copyWith(
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                          ],
                                        ),

                                        const SizedBox(height: 6),

                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                item['alamat_op'] ?? '-',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTypography.caption
                                                    .copyWith(
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getDigitalLabel(Map<String, dynamic> item) {
  final isDigital = item['is_digital'] ?? 0;
  return isDigital == 1 ? 'Digitalisasi' : 'Proses Digitalisasi';
}

PbChipType getDigitalType(Map<String, dynamic> item) {
  final isDigital = item['is_digital'] ?? 0;
  return isDigital == 1 ? PbChipType.success : PbChipType.warning;
}

String getTarifLabel(Map<String, dynamic> item) {
  final pungutTarif = item['pungut_tarif'] ?? 1;
  return pungutTarif == 1 ? 'Gratis' : 'Berbayar';
}

PbChipType getTarifType(Map<String, dynamic> item) {
  final pungutTarif = item['pungut_tarif'] ?? 1;
  return pungutTarif == 1 ? PbChipType.info : PbChipType.success;
}
