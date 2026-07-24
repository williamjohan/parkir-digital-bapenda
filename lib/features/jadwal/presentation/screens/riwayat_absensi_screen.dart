import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_datepicker_field.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/entities/riwayat_abensi_entity.dart';
import 'package:parkir_digital_bapenda/features/jadwal/presentation/cubit/riwayat_absensi_cubit.dart';
import 'package:parkir_digital_bapenda/features/jadwal/presentation/cubit/riwayat_absensi_state.dart';
import 'package:parkir_digital_bapenda/features/jadwal/presentation/widget/riwayat_absensi_card_item.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  late DateTimeRange _selectedRange;

  bool get _isSingleDay =>
      _selectedRange.start.year == _selectedRange.end.year &&
      _selectedRange.start.month == _selectedRange.end.month &&
      _selectedRange.start.day == _selectedRange.end.day;

  bool get _isTodaySelected {
    final now = DateTime.now();
    return _isSingleDay &&
        _selectedRange.start.year == now.year &&
        _selectedRange.start.month == now.month &&
        _selectedRange.start.day == now.day;
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _selectedRange = DateTimeRange(start: today, end: today);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRiwayat());
  }

  void _loadRiwayat() {
    context.read<RiwayatAbsensiCubit>().fetchJadwal(
      tglAwal: _selectedRange.start,
      tglAkhir: _selectedRange.end,
    );
  }

  void _onDateRangeChanged(DateTimeRange? range) {
    if (range == null) return;
    setState(() => _selectedRange = range);
    _loadRiwayat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Riwayat Absensi',
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
      ),
      body: Column(
        children: [
          _buildFilterHeader(),
          Expanded(
            child: BlocBuilder<RiwayatAbsensiCubit, RiwayatAbsensiState>(
              builder: (context, state) => _buildContent(state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: DateRangeField(
        title: 'Tanggal Absensi',
        initialRange: _selectedRange,
        onChanged: _onDateRangeChanged,
      ),
    );
  }

  Widget _buildContent(RiwayatAbsensiState state) {
    final isLoading = state.status == JadwalStatus.loading;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _loadRiwayat(),
      child: Skeletonizer(
        enabled: isLoading,
        child: switch (state.status) {
          JadwalStatus.loading => _buildResultList(state.jadwalFake ?? []),
          JadwalStatus.initial => _buildResultList(state.jadwalFake ?? []),
          JadwalStatus.failure => _buildErrorState(state.message),
          JadwalStatus.success => _buildResultList(state.jadwal ?? []),
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: AppColors.error.withValues(alpha: .55),
              ),
              const SizedBox(height: 16),
              Text(
                message.isNotEmpty ? message : 'Gagal memuat data jadwal.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyRegular,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultList(List<RiwayatAbsensiEntity> data) {
    final allObjek = data.expand((d) => d.objekList).toList();
    if (allObjek.isEmpty) return _buildEmptyState();

    if (data.length <= 1) {
      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        itemCount: allObjek.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            RiwayatAbsensiCard(record: allObjek[index]),
      );
    }

    final sorted = [...data]..sort((a, b) => b.tanggal.compareTo(a.tanggal));

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: [
        for (final group in sorted) ...[
          _buildDateHeader(group.tanggalString),
          const SizedBox(height: 10),
          for (final record in group.objekList) ...[
            RiwayatAbsensiCard(record: record),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
        ],
      ],
    );
  }

  Widget _buildDateHeader(String tanggalString) {
    return Row(
      children: [
        Text(
          tanggalString,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Divider(color: AppColors.border, height: 1)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.event_busy_rounded,
                  size: 56,
                  color: AppColors.primary.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isTodaySelected
                    ? 'Anda belum melakukan absensi hari ini'
                    : 'Tidak ada riwayat absensi pada tanggal ini',
                textAlign: TextAlign.center,
                style: AppTypography.bodySemiBold.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
