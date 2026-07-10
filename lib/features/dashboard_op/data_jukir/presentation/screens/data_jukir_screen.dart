import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/presentation/widgets/pendapatan_info_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/routes/app_routes.dart';
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
        title: Text(
          'Daftar Jukir',
          style: AppTypography.heading5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.primary, width: 1.0),
        ),
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: BlocBuilder<DataJukirCubit, DataJukirState>(
        builder: (context, state) {
          final items = state.isLoading ? state.dataFake : state.data;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                if (state.isLoading || items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Skeletonizer(
                      enabled: state.isLoading,
                      child: const PendapatanInfoCard(),
                    ),
                  ),
                Expanded(
                  child: Skeletonizer(
                    enabled: state.isLoading,
                    child: state.isLoading
                        ? ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, index) {
                              return DataJukirCard(
                                entity: items[index],
                                lihatRiwayatOnTap: () {},
                              );
                            },
                          )
                        : items.isEmpty
                        ? const _EmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, index) {
                              final entity = items[index];

                              return DataJukirCard(
                                entity: entity,
                                lihatRiwayatOnTap: () {
                                  context.pushNamed(
                                    AppRoutes.history,
                                    extra: {
                                      'isFree': false,
                                      'nop': widget.item['nop'],
                                      'idDevice': entity.idDevice,
                                    },
                                  );
                                },
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Belum ada data jukir',
            style: AppTypography.bodyRegular.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Data jukir akan muncul di sini.',
            style: AppTypography.bodySmall.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
