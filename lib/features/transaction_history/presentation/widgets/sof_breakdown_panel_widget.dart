// presentation/widgets/sof_breakdown_panel_widget.dart
import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/models/sof_summary_model.dart';

class SofBreakdownPanelWidget extends StatelessWidget {
  final List<SofSummaryModel> sofList;
  final bool isLoading;
  final String selectedKategori;
  final Future<void> Function()? onRefresh;

  const SofBreakdownPanelWidget({
    super.key,
    required this.sofList,
    this.isLoading = false,
    this.selectedKategori = 'SEMUA',
    this.onRefresh,
  });

  static const Color _motorColor = Color(0xFF10B981);
  static const Color _mobilColor = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    final items =
        sofList.where((e) => e.transaksiFor(selectedKategori) > 0).toList()
          ..sort(
            (a, b) => b
                .nominalFor(selectedKategori)
                .compareTo(a.nominalFor(selectedKategori)),
          );

    return Container(
      color: Colors.grey.shade50,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh ?? () async {},
                color: AppColors.primary,
                child: isLoading
                    ? Skeletonizer(
                        enabled: true,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(), // 🆕
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: 4,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              const _SofPlaceholderCard(),
                        ),
                      )
                    : items.isEmpty
                    ? ListView(
                        // 🆕 dibungkus ListView biar bisa ditarik walau kosong
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 300,
                            child: Center(
                              child: Text(
                                'Belum ada rekap jenis pembayaran',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textHint,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(), // 🆕
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final ui = SofUiHelper.resolve(item.sof);
                          return _SofMethodCard(
                            item: item,
                            ui: ui,
                            selectedKategori: selectedKategori,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _SofMethodCard extends StatelessWidget {
  final SofSummaryModel item;
  final ({IconData icon, Color color, String label}) ui;
  final String selectedKategori;

  const _SofMethodCard({
    required this.item,
    required this.ui,
    required this.selectedKategori,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: ui.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(ui.icon, size: 15, color: ui.color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ui.label,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                CurrencyFormatter.toIdr(
                  item.nominalFor(selectedKategori).toString(),
                ),
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildVehicleSection(),
        ],
      ),
    );
  }

  Widget _buildVehicleSection() {
    if (selectedKategori == 'MOBIL') {
      return _VehicleMiniCard(
        icon: Icons.directions_car,
        label: 'Mobil',
        color: SofBreakdownPanelWidget._mobilColor,
        count: item.jumlahMobil,
        nominal: item.nominalMobil,
      );
    }
    if (selectedKategori == 'MOTOR') {
      return _VehicleMiniCard(
        icon: Icons.two_wheeler,
        label: 'Motor',
        color: SofBreakdownPanelWidget._motorColor,
        count: item.jumlahMotor,
        nominal: item.nominalMotor,
      );
    }
    return Row(
      children: [
        Expanded(
          child: _VehicleMiniCard(
            icon: Icons.two_wheeler,
            label: 'Motor',
            color: SofBreakdownPanelWidget._motorColor,
            count: item.jumlahMotor,
            nominal: item.nominalMotor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _VehicleMiniCard(
            icon: Icons.directions_car,
            label: 'Mobil',
            color: SofBreakdownPanelWidget._mobilColor,
            count: item.jumlahMobil,
            nominal: item.nominalMobil,
          ),
        ),
      ],
    );
  }
}

class _VehicleMiniCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int count;
  final int nominal;

  const _VehicleMiniCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.count,
    required this.nominal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${count}x',
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              CurrencyFormatter.toIdr(nominal.toString()),
              style: AppTypography.caption.copyWith(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SofPlaceholderCard extends StatelessWidget {
  const _SofPlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(child: _MiniPlaceholder()),
              SizedBox(width: 8),
              Expanded(child: _MiniPlaceholder()),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniPlaceholder extends StatelessWidget {
  const _MiniPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Motor',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text('00x', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 2),
          Text('Rp000.000', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
