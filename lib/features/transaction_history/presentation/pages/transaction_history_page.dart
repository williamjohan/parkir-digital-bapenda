import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/features/printer/presentation/cubit/printer_cubit.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/widgets/range_filter_widget.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/widgets/sof_breakdown_panel_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/design_system/components/pb_permission_dialog.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/components/struck/pb_ticket_preview_widget.dart';
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
  final Map<String, dynamic>? item;

  const TransactionHistoryPage({
    super.key,
    this.initialDate,
    required this.isFree,
    this.nop,
    this.idDevice,
    this.item,
  });

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _sofPanelController;

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
    _sofPanelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 0,
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

      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final current = _scrollController.position.pixels;
        if (current >= maxScroll * 0.9) {
          context.read<TransactionHistoryCubit>().loadMoreItems();
        }
      }
    });
  }

  @override
  void dispose() {
    _sofPanelController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openSofPanel(TransactionHistoryState state) {
    final isFirstOpen =
        _sofPanelController.value < 0.5 &&
        state is TransactionHistoryLoaded &&
        state.sofDetailList.isEmpty;
    _sofPanelController.animateTo(1, curve: Curves.easeOut);
    if (isFirstOpen) {
      context.read<TransactionHistoryCubit>().fetchSofBreakdown();
    }
  }

  void _closeSofPanel() =>
      _sofPanelController.animateTo(0, curve: Curves.easeOut);

  void _toggleSofPanel(TransactionHistoryState state) {
    _sofPanelController.value > 0.5 ? _closeSofPanel() : _openSofPanel(state);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener Pertama: Untuk menangkap error dari Riwayat Transaksi
        BlocListener<TransactionHistoryCubit, TransactionHistoryState>(
          listener: (context, state) {
            if (state is TransactionHistoryError) {
              PbStatusSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
        ),

        // Listener Kedua: Untuk menangkap error dari Printer
        BlocListener<PrinterCubit, PrinterState>(
          listener: (context, state) {
            if (state is PrinterError) {
              PbStatusSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
            // 🚀 TAMBAHKAN LISTENER INI UNTUK MENAMPILKAN DIALOG
            else if (state is PrinterPermissionRequiresAction) {
              PbPermissionDialog.show(
                context,
                title: 'Akses Izin Diperlukan',
                description:
                    'Anda telah menolak izin Perangkat Sekitar (Bluetooth) atau Lokasi aplikasi ini.\n\nMohon aktifkan izin tersebut secara manual melalui pengaturan aplikasi agar fitur printer dapat digunakan kembali.',
              );
            }
          },
        ),
      ],
      child: BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
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
                            final start = DateTime.parse(
                              "$startDate $startTime",
                            );
                            final end = DateTime.parse("$endDate $endTime");
                            setState(() {
                              _startDate = start;
                              _endDate = end;
                            });
                            context
                                .read<TransactionHistoryCubit>()
                                .fetchHistory(
                                  start,
                                  end,
                                  widget.nop ?? '',
                                  widget.idDevice ?? '',
                                );
                          },
                    ),
                    if (state is TransactionHistoryLoaded)
                      _buildFilterSection(state),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double availableWidth = constraints.maxWidth;

                          return ClipRect(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onHorizontalDragUpdate: (details) {
                                if (state is! TransactionHistoryLoaded) return;
                                final delta =
                                    details.primaryDelta! / availableWidth;
                                _sofPanelController.value =
                                    (_sofPanelController.value + delta).clamp(
                                      0.0,
                                      1.0,
                                    );
                              },
                              onHorizontalDragEnd: (details) {
                                if (state is! TransactionHistoryLoaded) return;
                                final velocity = details.primaryVelocity ?? 0;
                                const flingThreshold = 300.0;
                                if (velocity > flingThreshold) {
                                  _openSofPanel(state);
                                } else if (velocity < -flingThreshold) {
                                  _closeSofPanel();
                                } else if (_sofPanelController.value > 0.5) {
                                  _openSofPanel(state);
                                } else {
                                  _closeSofPanel();
                                }
                              },
                              child: Stack(
                                children: [
                                  if (state is TransactionHistoryLoaded)
                                    AnimatedBuilder(
                                      animation: _sofPanelController,
                                      builder: (context, child) => Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left:
                                            (_sofPanelController.value - 1) *
                                            availableWidth,
                                        width: availableWidth,
                                        child: child!,
                                      ),
                                      child: SofBreakdownPanelWidget(
                                        sofList: state.sofDetailList,
                                        isLoading: state.isSofPanelLoading,
                                        selectedKategori:
                                            state.selectedKategori,
                                      ),
                                    ),
                                  AnimatedBuilder(
                                    animation: _sofPanelController,
                                    builder: (context, child) => Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left:
                                          _sofPanelController.value *
                                          availableWidth,
                                      width: availableWidth,
                                      child: child!,
                                    ),
                                    child: _buildScrollContent(state),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                floatingActionButton: state is TransactionHistoryLoaded
                    ? AnimatedBuilder(
                        animation: _sofPanelController,
                        builder: (context, _) {
                          final isOpen = _sofPanelController.value > 0.5;
                          return FloatingActionButton(
                            heroTag: 'sof_panel_fab',
                            onPressed: () => _toggleSofPanel(state),
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              isOpen ? Icons.close : Icons.payments_rounded,
                              color: Colors.white,
                            ),
                          );
                        },
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(TransactionHistoryLoaded state) {
    final bool isFiltering = state.isFilterLoading;
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
                  isFiltering,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  'MOBIL',
                  state.selectedKategori,
                  'Mobil',
                  isFiltering,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  'MOTOR',
                  state.selectedKategori,
                  'Motor',
                  isFiltering,
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
      final allFiltered = state.filteredTransactions;
      final data = state.visibleTransactions;
      final isFiltering = state.isFilterLoading;

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
                    child: Skeletonizer(
                      // 🆕 bungkus recap
                      enabled: isFiltering,
                      child: HistoryRecapWidget(
                        title: _getDynamicRecapTitle(),
                        roda2: state.roda2.toString(),
                        roda4: state.roda4.toString(),
                        totalPendapatan: state.totalPendapatan.toString(),
                        persentasePajak: state.persentasePajak.toString(),
                        nominalPajak: state.totalPajak.toString(),
                        totalBersih: state.totalBersih.toString(),
                        sofBreakdown: state.sofBreakdown,
                        isFree: widget.isFree,
                      ),
                    ),
                  ),
                ),
                allFiltered.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(),
                      )
                    : Skeletonizer.sliver(
                        enabled: isFiltering,
                        child: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return HistoryCardWidget(
                              item: data[index],
                              onPrint: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) {
                                    return Dialog(
                                      insetPadding: const EdgeInsets.all(24),
                                      child: PbPreviewTicketWidget(
                                        item: data[index],
                                        isPrinterReady: true,
                                        okPressed: () {
                                          Navigator.pop(context);
                                        },
                                        printPressed: () async {
                                          // Navigator.pop(context);

                                          // proses print di sini
                                          return await context
                                              .read<PrinterCubit>()
                                              .printReceipt(data[index]);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }, childCount: data.length),
                        ),
                      ),

                if (state.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
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
    bool isDisabled,
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
      onSelected: isDisabled
          ? null
          : (bool selected) {
              if (selected) {
                context.read<TransactionHistoryCubit>().applyFilter(
                  kategori: value,
                );
              }
            },
    );
  }
}
