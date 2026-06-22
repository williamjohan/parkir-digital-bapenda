import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_text_field.dart';
import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';

import '../../../../core/design_system/components/pb_action_menu_card.dart';
import '../../../../core/design_system/components/pb_basic_bottom_sheet.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/routes/app_routes.dart';
import '../cubit/search_op/search_op_cubit.dart';
import '../cubit/search_op/search_op_state.dart';

class SearchOpPage extends StatefulWidget {
  final RoleLoginDigitalParkir role;

  const SearchOpPage({super.key, required this.role});

  @override
  State<SearchOpPage> createState() => _SearchOpPageState();
}

class _SearchOpPageState extends State<SearchOpPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    context.read<SearchOpCubit>().getNopList(type: SearchOpType.digital);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      final type = switch (_tabController.index) {
        0 => SearchOpType.digital,
        1 => SearchOpType.nonDigital,
        2 => SearchOpType.free,
        _ => SearchOpType.digital,
      };

      context.read<SearchOpCubit>().changeTab(type);

      searchController.clear();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PbTextField(
              controller: searchController,
              hintText: "Cari berdasarkan nama / alamat ...",
              onChanged: (value) {
                context.read<SearchOpCubit>().searchNopAlamat(value);
              },
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                tabs: const [
                  Tab(text: 'Digitalisasi'),
                  Tab(text: 'Non-Digital'),
                  Tab(text: 'Parkir Bebas'),
                ],
              ),
            ),

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
                    itemCount: state.filteredNopList.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = state.filteredNopList[index];

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        title: Text(
                          item['nama_op'] ?? '-',
                          style: AppTypography.bodySemiBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        subtitle: Text(
                          item['alamat_op'] ?? '-',
                          style: AppTypography.caption,
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.grey.shade400,
                        ),
                        onTap: () async {
                          final isDigital = (item['is_digital'] ?? 0) == 1;
                          final isFree = (item['pungut_tarif'] ?? 0) == 1;
                          if (widget.role == RoleLoginDigitalParkir.wp) {
                            Navigator.pop<Map<String, dynamic>>(context, item);
                            return;
                          }

                          if (widget.role == RoleLoginDigitalParkir.bapenda) {
                            if (isDigital && !isFree) {
                              await PbBasicBottomSheet.show(
                                context: context,
                                title: 'Pilih Aksi',
                                subTitle:
                                    'Apa yang ingin Anda lakukan untuk objek pajak ini?',
                                child: Column(
                                  children: [
                                    ActionMenuCard(
                                      icon: Icons.history_rounded,
                                      title: 'Lihat Riwayat',
                                      subtitle:
                                          'Lihat seluruh riwayat transaksi objek pajak',
                                      onTap: () {
                                        Navigator.pop(context);

                                        context.pushNamed(
                                          AppRoutes.history,
                                          extra: {
                                            'isFree': isFree,
                                            'nop': item['nop'],
                                          },
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 12),

                                    ActionMenuCard(
                                      icon: Icons.add_circle_outline_rounded,
                                      title: 'Tambah Transaksi',
                                      subtitle:
                                          'Input transaksi baru untuk objek pajak ini',
                                      onTap: () {
                                        Navigator.pop(context);

                                        context.pushNamed(
                                          AppRoutes.transaction,
                                          extra: {
                                            'isFree': isFree,
                                            'itemOP': item,
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else if (isFree) {
                              context.pushNamed(
                                AppRoutes.history,
                                extra: {'isFree': isFree, 'nop': item['nop']},
                              );
                            }
                          }
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
