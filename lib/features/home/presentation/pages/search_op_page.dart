import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_text_field.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../cubit/search_op/search_op_cubit.dart';
import '../cubit/search_op/search_op_state.dart';

class SearchOpPage extends StatefulWidget {
  const SearchOpPage({super.key});

  @override
  State<SearchOpPage> createState() => _SearchOpPageState();
}

class _SearchOpPageState extends State<SearchOpPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<SearchOpCubit>().getNopList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Objek Pajak', style: AppTypography.heading5),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PbTextField(
              controller: searchController,
              hintText: "Cari objek pajak",
              onChanged: (value) {
                context.read<SearchOpCubit>().searchNop(value);
              },
            ),
            Expanded(
              child: BlocBuilder<SearchOpCubit, SearchOpState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.filteredNopList.isEmpty) {
                    return const Center(child: Text('Data tidak ditemukan'));
                  }

                  return ListView.builder(
                    itemCount: state.filteredNopList.length,
                    itemBuilder: (context, index) {
                      final item = state.filteredNopList[index];

                      return ListTile(
                        title: Text(
                          item['nama_op'] ?? '-',
                          style: AppTypography.bodySemiBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        subtitle: Text(
                          item['nop'] ?? '-',
                          style: AppTypography.caption,
                        ),
                        onTap: () {
                          Navigator.pop<Map<String, dynamic>>(context, item);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
