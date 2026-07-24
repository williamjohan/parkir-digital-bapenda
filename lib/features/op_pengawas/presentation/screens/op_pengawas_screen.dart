import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/design_system/components/pb_text_field.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/op_pengawas_entity.dart';
import '../dummy_op_pengawas_list.dart';
import '../widgets/card_op_pengawas.dart';
import '../widgets/filter_op_pengawas.dart';

class OpPengawasScreen extends StatefulWidget {
  const OpPengawasScreen({super.key});

  @override
  State<OpPengawasScreen> createState() => _OpPengawasScreenState();
}

class _OpPengawasScreenState extends State<OpPengawasScreen> {
  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;

  int selectedFilter = 0;

  List<OpPengawasEntity> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = dummyOpPengawas;
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _applyFilter() {
    List<OpPengawasEntity> result = dummyOpPengawas;

    switch (selectedFilter) {
      case 1:
        result = result
            .where((e) => e.jenisPengawasan == JenisPengawasan.dishub)
            .toList();
        break;

      case 2:
        result = result
            .where((e) => e.jenisPengawasan == JenisPengawasan.bapenda)
            .toList();
        break;
    }

    final keyword = searchController.text.trim().toLowerCase();

    if (keyword.isNotEmpty) {
      result = result.where((e) {
        return e.namaOp.toLowerCase().contains(keyword) ||
            e.alamat.toLowerCase().contains(keyword);
      }).toList();
    }

    setState(() {
      filteredData = result;
    });
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 400), _applyFilter);
  }

  void _onFilterChanged(int index) {
    setState(() {
      selectedFilter = index;
    });

    _applyFilter();
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
          shape: const Border(bottom: BorderSide(color: AppColors.primary)),
          elevation: 0,
          foregroundColor: Colors.black,
          iconTheme: const IconThemeData(color: AppColors.primary),
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
                child: filteredData.isEmpty
                    ? const Center(child: Text('Data tidak ditemukan'))
                    : ListView.separated(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: filteredData.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = filteredData[index];

                          return OpPengawasCard(
                            item: item,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              // TODO:
                              // context.pushNamed(...);
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
