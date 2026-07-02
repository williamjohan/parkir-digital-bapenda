import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/presentation/widgets/pendapatan_info_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/storage/secure_storage_manager.dart';
import '../cubit/data_jukir_cubit.dart';
import '../cubit/data_jukir_state.dart';
import '../widgets/data_jukir_card.dart';

class DataJukirScreen extends StatefulWidget {
  final Map<String, dynamic>? item;
  final bool isPengawas;
  final bool isShowPendapatan;

  const DataJukirScreen({
    super.key,
    this.item,
    this.isPengawas = false,
    this.isShowPendapatan = true,
  });

  @override
  State<DataJukirScreen> createState() => _DataJukirScreenState();
}

class _DataJukirScreenState extends State<DataJukirScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    late final String nop;

    if (widget.isPengawas) {
      // final profile = await locator<ISecureStorageManager>().getJukirProfile();

      // nop = profile?['nop'] ?? '';
      nop = '357801000390703149';
    } else {
      nop = widget.item?['nop'] ?? '';
    }

    if (!mounted) return;

    context.read<DataJukirCubit>().getDataJukir(nop);
  }

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
          final items = state.isLoading ? state.dataFake : state.data;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                if (widget.isShowPendapatan)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Skeletonizer(
                      enabled: state.isLoading,
                      child: PendapatanInfoCard(),
                    ),
                  ),
                Expanded(
                  child: Skeletonizer(
                    enabled: state.isLoading,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final entity = items[index];

                        return DataJukirCard(
                          isShowPendapatan: widget.isShowPendapatan,
                          entity: entity,
                          lihatRiwayatOnTap: state.isLoading
                              ? null
                              : () {
                                  context.pushNamed(
                                    AppRoutes.history,
                                    extra: {
                                      'isFree': false,
                                      'nop': widget.item!['nop'],
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
