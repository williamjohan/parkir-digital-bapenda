import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_datepicker_field.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../widget/jadwal_card_item.dart';

// ===========================================================================
// 🚧 DUMMY MODEL & GENERATOR — hapus/ganti kalau backend & cubit history udah siap
// ===========================================================================
class AbsensiRecordDummy {
  final DateTime tanggal;
  final String namaNop;
  final String nop;
  final String jamCheckIn;
  final String? jamCheckOut;
  final int motorCheckIn;
  final int mobilCheckIn;
  final int? motorCheckOut;
  final int? mobilCheckOut;
  final List<InstrumenTersediaDummy>
  instrumenCheckIn; // 🆕 ganti dari `instrumen`
  final List<InstrumenTersediaDummy>?
  instrumenCheckOut; // 🆕 null = belum checkout

  const AbsensiRecordDummy({
    required this.tanggal,
    required this.namaNop,
    required this.nop,
    required this.jamCheckIn,
    this.jamCheckOut,
    required this.motorCheckIn,
    required this.mobilCheckIn,
    this.motorCheckOut,
    this.mobilCheckOut,
    required this.instrumenCheckIn, // 🆕
    this.instrumenCheckOut, // 🆕
  });
}

class InstrumenTersediaDummy {
  final String nama;
  final bool tersedia;

  const InstrumenTersediaDummy({required this.nama, required this.tersedia});
}

const List<String> _kDummyNopNames = [
  'Toko Sinar Jaya',
  'Ruko Blok C-12',
  'Gedung Perkantoran Graha Niaga',
  'Pasar Turi Kios 45',
  'Apartemen Puncak Permai',
];

// 🆕 pool nama alat — sengaja lebih dari 3, biar kelihatan Wrap-nya
// beneran dinamis (kadang 2 alat, kadang 5 alat)
const List<String> _kDummyInstrumentPool = [
  'EDC',
  'QRIS',
  'TSpark',
  'E-Retribusi',
  'Kartu Langganan',
];

List<InstrumenTersediaDummy> _generateDummyInstrumen(int seed) {
  final count = 2 + seed % (_kDummyInstrumentPool.length - 1); // 2..5
  return List.generate(count, (i) {
    final nama =
        _kDummyInstrumentPool[(seed + i) % _kDummyInstrumentPool.length];
    return InstrumenTersediaDummy(nama: nama, tersedia: (seed + i) % 2 == 0);
  });
}

List<AbsensiRecordDummy> _generateDummyRecordsForDate(DateTime tanggal) {
  final now = DateTime.now();
  final isToday =
      tanggal.year == now.year &&
      tanggal.month == now.month &&
      tanggal.day == now.day;

  final seedBase = tanggal.day + tanggal.month * 3;
  final count = isToday ? (seedBase % 2) : (seedBase % 3);

  return List.generate(count, (i) {
    final seed = seedBase + i;
    final jamMasukJam = 7 + (i % 3);
    final sudahCheckOut = !isToday || i == 0;

    return AbsensiRecordDummy(
      tanggal: tanggal,
      namaNop: _kDummyNopNames[seed % _kDummyNopNames.length],
      nop: _generateDummyNop(seed),
      jamCheckIn: '${jamMasukJam.toString().padLeft(2, '0')}:15',
      jamCheckOut: sudahCheckOut
          ? '${(jamMasukJam + 8).toString().padLeft(2, '0')}:30'
          : null,
      motorCheckIn: 10 + seed % 15,
      mobilCheckIn: 3 + seed % 8,
      motorCheckOut: sudahCheckOut ? 12 + seed % 20 : null,
      mobilCheckOut: sudahCheckOut ? 4 + seed % 10 : null,
      instrumenCheckIn: _generateDummyInstrumen(seed), // 🆕 seed asli
      instrumenCheckOut: sudahCheckOut
          ? _generateDummyInstrumen(
              seed + 7,
            ) // 🆕 seed beda → hasil beda dari checkin
          : null, // 🆕 belum checkout → null
    );
  });
}

String _generateDummyNop(int seed) {
  final kec = (100 + seed % 50).toString().padLeft(3, '0');
  final kel = (700 + (seed * 3) % 90).toString().padLeft(3, '0');
  final blok = (10 + seed % 20).toString().padLeft(3, '0');
  final urut = (1000 + seed % 899).toString().padLeft(4, '0');
  final gab = (seed % 9).toString();
  return '35.78.$kec.$kel.$blok-$urut.$gab';
}

List<AbsensiRecordDummy> _generateDummyRecords(DateTimeRange range) {
  final result = <AbsensiRecordDummy>[];
  var cursor = DateTime(range.end.year, range.end.month, range.end.day);
  final start = DateTime(range.start.year, range.start.month, range.start.day);

  while (!cursor.isBefore(start)) {
    result.addAll(_generateDummyRecordsForDate(cursor));
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return result;
}

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  late DateTimeRange _selectedRange;
  bool _isLoading = true;
  List<AbsensiRecordDummy> _records = [];

  final DateFormat _dateHeaderFormatter = DateFormat(
    'EEEE, dd MMM yyyy',
    'id_ID',
  );

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
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    setState(() => _isLoading = true);

    // TODO: ganti dengan pemanggilan cubit/usecase asli begitu backend siap
    await Future.delayed(const Duration(milliseconds: 500));
    final data = _generateDummyRecords(_selectedRange);

    if (!mounted) return;
    setState(() {
      _records = data;
      _isLoading = false;
    });
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
          Expanded(child: _buildContent()),
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

  Widget _buildContent() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadRiwayat,
      child: Skeletonizer(
        enabled: _isLoading,
        child: _isLoading ? _buildLoadingList() : _buildResultList(),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => ObjekAbsensiCard(
        record: AbsensiRecordDummy(
          tanggal: DateTime.now(),
          namaNop: 'Memuat data objek pengawasan',
          nop: '00.00.000.000.000-0000.0',
          jamCheckIn: '00:00',
          jamCheckOut: '00:00',
          motorCheckIn: 0,
          mobilCheckIn: 0,
          motorCheckOut: 0,
          mobilCheckOut: 0,
          instrumenCheckIn: const [
            // 🆕
            InstrumenTersediaDummy(nama: 'EDC', tersedia: true),
            InstrumenTersediaDummy(nama: 'QRIS', tersedia: true),
            InstrumenTersediaDummy(nama: 'TSpark', tersedia: true),
          ],
          instrumenCheckOut: const [
            // 🆕
            InstrumenTersediaDummy(nama: 'EDC', tersedia: true),
            InstrumenTersediaDummy(nama: 'QRIS', tersedia: true),
            InstrumenTersediaDummy(nama: 'TSpark', tersedia: true),
          ],
        ),
      ),
    );
  }

  Widget _buildResultList() {
    if (_records.isEmpty) {
      return _buildEmptyState();
    }

    // Kasus 1 hari (default): tampilkan card langsung, tanpa header tanggal
    if (_isSingleDay) {
      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        itemCount: _records.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            ObjekAbsensiCard(record: _records[index]),
      );
    }

    // Kasus multi-hari: kelompokkan per tanggal dengan header tipis
    final grouped = <DateTime, List<AbsensiRecordDummy>>{};
    for (final r in _records) {
      final key = DateTime(r.tanggal.year, r.tanggal.month, r.tanggal.day);
      grouped.putIfAbsent(key, () => []).add(r);
    }
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: [
        for (final date in sortedDates) ...[
          _buildDateHeader(date),
          const SizedBox(height: 10),
          for (final record in grouped[date]!) ...[
            ObjekAbsensiCard(record: record),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
        ],
      ],
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Row(
      children: [
        Text(
          _dateHeaderFormatter.format(date),
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
