import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../cubit/data_jukir_cubit.dart';
import '../cubit/data_jukir_state.dart';
import '../widgets/data_jukir_card.dart';

class DataJukirScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const DataJukirScreen({super.key, required this.item});

  @override
  State<DataJukirScreen> createState() => _DataJukirScreenState();
}

class _DataJukirScreenState extends State<DataJukirScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Daftar Jukir', style: AppTypography.heading5),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<DataJukirCubit, DataJukirState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Expanded(
                  child: Skeletonizer(
                    enabled: state.isLoading,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.data.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        return DataJukirCard(
                          entity: state.data[index],
                          lihatRiwayatOnTap: () {},
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
