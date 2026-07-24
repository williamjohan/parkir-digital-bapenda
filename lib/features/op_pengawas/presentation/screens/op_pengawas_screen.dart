import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/design_system/components/pb_basic_bottom_sheet.dart';
import '../../../../core/design_system/components/pb_text_field.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/enums/app_enums.dart';
import '../cubit/op_pengawasan_cubit.dart';
import '../cubit/op_pengawasan_state.dart';
import '../widgets/card_op_pengawas.dart';
import '../widgets/filter_op_pengawas.dart';
import '../widgets/shift_pengawasan_bottom_sheet.dart';

class OpPengawasScreen extends StatefulWidget {
  const OpPengawasScreen({super.key});

  @override
  State<OpPengawasScreen> createState() => _OpPengawasScreenState();
}

class _OpPengawasScreenState extends State<OpPengawasScreen> {
  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;

  int selectedFilter = 0;

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  JenisPengawasan? _selectedJenis() {
    switch (selectedFilter) {
      case 1:
        return JenisPengawasan.dishub;
      case 2:
        return JenisPengawasan.bapenda;
      default:
        return null;
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      context.read<OpPengawasanCubit>().searchAndFilter(
        keyword: value,
        jenis: _selectedJenis(),
      );
    });
  }

  void _onFilterChanged(int index) {
    setState(() {
      selectedFilter = index;
    });

    context.read<OpPengawasanCubit>().searchAndFilter(
      keyword: searchController.text,
      jenis: _selectedJenis(),
    );
  }

  Future<void> _refresh() async {
    await context.read<OpPengawasanCubit>().getOpPengawasan();

    if (!mounted) return;

    context.read<OpPengawasanCubit>().searchAndFilter(
      keyword: searchController.text,
      jenis: _selectedJenis(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            'Objek Pajak Pengawasan',
            style: AppTypography.heading5.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.surface,
          scrolledUnderElevation: 0,
          elevation: 0,
          foregroundColor: Colors.black,
          iconTheme: const IconThemeData(color: AppColors.primary),
          shape: const Border(bottom: BorderSide(color: AppColors.primary)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
              PbTextField(
                controller: searchController,
                hintText: 'Cari berdasarkan nama / alamat...',
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 12),
              OpPengawasFilterWidget(
                selectedIndex: selectedFilter,
                onChanged: _onFilterChanged,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocConsumer<OpPengawasanCubit, OpPengawasanState>(
                  listener: (context, state) {
                    if (state.errorMessage != null &&
                        state.errorMessage!.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (!state.isLoading &&
                        state.filteredOpPengawasanList.isEmpty) {
                      return const Center(child: Text('Data tidak ditemukan'));
                    }

                    return Skeletonizer(
                      enabled: state.isLoading,
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: state.filteredOpPengawasanList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = state.filteredOpPengawasanList[index];

                            return OpPengawasCard(
                              item: item,
                              onTap: state.isLoading
                                  ? null
                                  : () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      PbBasicBottomSheet.show(
                                        context: context,
                                        title: 'Pilih Shift Pengawasan',
                                        subTitle:
                                            'Pilih shift sebelum memulai pengawasan.',
                                        child: ShiftPengawasanBottomSheet(
                                          // 🚀 CALLBACK TUNGGAL YANG ASINKRON
                                          onSelected: (shiftYangDipilih) async {
                                            // 1. SIMPAN DAN TUNGGU SAMPAI SELESAI 100%
                                            await context
                                                .read<OpPengawasanCubit>()
                                                .changeShift(
                                                  shiftYangDipilih,
                                                  item,
                                                );

                                            // 2. TUTUP LAYAR DENGAN AMAN
                                            if (context.mounted) {
                                              Navigator.pop(
                                                context,
                                              ); // Menutup Bottom Sheet
                                              Navigator.pop(
                                                context,
                                              ); // Menutup Layar Pencarian
                                            }
                                          },
                                        ),
                                      );
                                    },
                            );
                          },
                        ),
                      ),
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
