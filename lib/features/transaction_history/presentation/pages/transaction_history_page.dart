import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/widgets/range_filter_widget.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../shared/loading/loading_overlay.dart';
import '../cubit/transaction_history_cubit.dart';
import '../cubit/transaction_history_state.dart';
import '../widgets/history_card_widget.dart';
import '../widgets/history_recap_widget.dart'; // 🚀 IMPORT WIDGET ASLI

class TransactionHistoryPage extends StatefulWidget {
  final DateTime? initialDate;
  final bool isFree;
  final String? nop;
  final String? idDevice;

  const TransactionHistoryPage({
    super.key,
    this.initialDate,
    required this.isFree,
    this.nop,
    this.idDevice,
  });

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  bool _isScrolledPastRecap = false;
  bool _showOverlayRecap = false;

  late DateTime _startDate;
  late DateTime _endDate;

  String _getDynamicRecapTitle() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day);

    if (start == today && end == today) {
      return "REKAP HARI INI";
    }

    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Ags",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];

    if (start == end) {
      return "REKAP ${start.day} ${months[start.month - 1]} ${start.year}";
    }

    if (start.month == end.month && start.year == end.year) {
      return "REKAP ${start.day} - ${end.day} ${months[end.month - 1]} ${end.year}";
    } else if (start.year == end.year) {
      return "REKAP ${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]} ${end.year}";
    } else {
      return "REKAP ${start.day} ${months[start.month - 1]} ${start.year} - ${end.day} ${months[end.month - 1]} ${end.year}";
    }
  }

  @override
  void initState() {
    super.initState();

    final targetDate = widget.initialDate ?? DateTime.now();

    _startDate = DateTime(targetDate.year, targetDate.month, targetDate.day);
    _endDate = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      23,
      59,
      59,
    );

    context.read<TransactionHistoryCubit>().fetchHistory(
      _startDate,
      _endDate,
      widget.nop ?? '',
      widget.idDevice ?? '',
    );
    _scrollController.addListener(() {
      if (_scrollController.offset > 180 && !_isScrolledPastRecap) {
        setState(() => _isScrolledPastRecap = true);
      } else if (_scrollController.offset <= 180 && _isScrolledPastRecap) {
        setState(() {
          _isScrolledPastRecap = false;
          _showOverlayRecap =
              false; // Otomatis tutup overlay jika user manual scroll ke paling atas
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionHistoryCubit, TransactionHistoryState>(
      listener: (context, state) {
        if (state is TransactionHistoryError) {
          PbStatusSnackbar.show(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is TransactionHistoryLoading;
        return LoadingOverlay(
          isLoading: isLoading,
          child: SafeArea(
            bottom: true,
            top: false,
            child: Scaffold(
              backgroundColor: Colors.grey.shade50,
              appBar: AppBar(
                title: Text(
                  'Riwayat Pendapatan',
                  style: AppTypography.heading5.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                backgroundColor: AppColors.surface,
                elevation: 0,
                foregroundColor: Colors.black,
                iconTheme: const IconThemeData(color: AppColors.primary),
              ),
              body: Column(
                children: [
                  RangeFilterWidget(
                    onApply:
                        ({
                          required String startDate,
                          required String endDate,
                          required String startTime,
                          required String endTime,
                        }) {
                          final start = DateTime.parse("$startDate $startTime");
                          final end = DateTime.parse("$endDate $endTime");
                          setState(() {
                            _startDate = start;
                            _endDate = end;
                          });
                          context.read<TransactionHistoryCubit>().fetchHistory(
                            start,
                            end,
                            widget.nop ?? '',
                            widget.idDevice ?? '',
                          );
                        },
                  ),
                  if (state is TransactionHistoryLoaded && widget.nop != null)
                    _buildFilterSection(state),
                  Expanded(child: _buildScrollContent(state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(TransactionHistoryLoaded state) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  'SEMUA',
                  state.selectedKategori,
                  'Semua',
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  'MOBIL',
                  state.selectedKategori,
                  'Mobil',
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  'MOTOR',
                  state.selectedKategori,
                  'Motor',
                ),
              ],
            ),
          ),
        ),
        const Divider(color: AppColors.textHint),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: AppColors.textHint),
          SizedBox(height: 16),
          Text(
            'Tidak ada transaksi untuk filter ini.',
            style: TextStyle(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollContent(TransactionHistoryState state) {
    if (state is TransactionHistoryError) {
      return Center(child: Text(state.message));
    }
    if (state is TransactionHistoryLoaded) {
      final data = state.filteredTransactions;

      return Stack(
        children: [
          RefreshIndicator(
            onRefresh: () =>
                context.read<TransactionHistoryCubit>().fetchHistory(
                  _startDate,
                  _endDate,
                  widget.nop ?? '',
                  widget.idDevice ?? '',
                ),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: (() {
                      return HistoryRecapWidget(
                        title: _getDynamicRecapTitle(),
                        roda2: state.roda2.toString(),
                        roda4: state.roda4.toString(),

                        totalPendapatan: state.totalPendapatan.toString(),
                        persentasePajak: state.persentasePajak.toString(),
                        nominalPajak: state.totalPajak.toString(),
                        totalBersih: state.totalBersih.toString(),

                        isFree: widget.isFree,
                      );
                    })(),
                  ),
                ),
                data.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return HistoryCardWidget(item: data[index]);
                        }, childCount: data.length),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),

          IgnorePointer(
            ignoring: !_showOverlayRecap,
            child: GestureDetector(
              onTap: () {
                setState(() => _showOverlayRecap = false);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                color: _showOverlayRecap
                    ? Colors.black.withValues(
                        alpha: 0.6,
                      ) // Gelap transparan saat aktif
                    : Colors.transparent, // Tembus pandang saat tidak aktif
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack, // Animasi memantul elegan
            top: _showOverlayRecap
                ? 16
                : -300, // Sembunyikan jauh ke atas jika false
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  setState(() => _showOverlayRecap = false);
                }
              },
              child: Column(
                children: [
                  (() {
                    return HistoryRecapWidget(
                      title: _getDynamicRecapTitle(),
                      roda2: state.roda2.toString(),
                      roda4: state.roda4.toString(),

                      totalPendapatan: state.totalPendapatan.toString(),
                      persentasePajak: state.persentasePajak.toString(),
                      nominalPajak: state.totalPajak.toString(),
                      totalBersih: state.totalBersih.toString(),

                      isFree: widget.isFree,
                    );
                  })(),
                  GestureDetector(
                    onTap: () => setState(() => _showOverlayRecap = false),
                    child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: (_isScrolledPastRecap && !_showOverlayRecap) ? 0 : -50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => setState(() => _showOverlayRecap = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Lihat Rekap",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildFilterChip(
    BuildContext context,
    String value,
    String selectedValue,
    String label,
  ) {
    final bool isSelected = value == selectedValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.blue.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue.shade800 : Colors.black54,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300),
      onSelected: (bool selected) {
        if (selected) {
          context.read<TransactionHistoryCubit>().applyLocalFilter(
            kategori: value,
          );
        }
      },
    );
  }
}
