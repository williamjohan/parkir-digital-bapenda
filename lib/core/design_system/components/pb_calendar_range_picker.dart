import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PbCalendarRangePicker extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const PbCalendarRangePicker({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
  });

  static Future<DateTimeRange?> show({
    required BuildContext context,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
  }) {
    return showDialog<DateTimeRange>(
      context: context,
      builder: (context) => PbCalendarRangePicker(
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
      ),
    );
  }

  @override
  State<PbCalendarRangePicker> createState() => _PbCalendarRangePickerState();
}

class _PbCalendarRangePickerState extends State<PbCalendarRangePicker> {
  late DateTime _currentMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _weekDays = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];

  // [ENHANCE]: Ambil tanggal hari ini (dinormalkan ke jam 00:00:00 untuk perbandingan presisi)
  late final DateTime _today;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _currentMonth = DateTime(
      (_startDate ?? DateTime.now()).year,
      (_startDate ?? DateTime.now()).month,
    );

    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
  }

  void _handleDayTap(DateTime date) {
    setState(() {
      if (_startDate == null) {
        _startDate = date;
      } else if (_endDate == null) {
        if (date.isBefore(_startDate!)) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      } else {
        _startDate = date;
        _endDate = null;
      }
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + offset,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A90E2);
    const Color highlightColor = Color(0xFFE3F2FD);

    final int daysInMonth = DateUtils.getDaysInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    final DateTime firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final int firstDayOffset = (firstDayOfMonth.weekday - 1) % 7;

    // [ENHANCE]: Cek apakah bulan yang tampil adalah bulan saat ini
    final bool isCurrentMonth =
        _currentMonth.year == _today.year &&
        _currentMonth.month == _today.month;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- HEADER BULAN & TAHUN ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  DateFormat('MMMM yyyy', 'id_ID').format(_currentMonth),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: isCurrentMonth
                        ? Colors.grey.shade300
                        : Colors.black87,
                  ),
                  onPressed: isCurrentMonth ? null : () => _changeMonth(1),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- NAMA HARI ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weekDays
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),

            // --- GRID TANGGAL ---
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                // 🚀 [PERBAIKAN 1]: Mengubah dari 1.2 menjadi 1.0 (Persegi)
                // Ini membuat kotak tanggal lebih tinggi dan area sentuh vertikalnya jauh lebih besar.
                childAspectRatio: 1.0,
              ),
              itemCount: daysInMonth + firstDayOffset,
              itemBuilder: (context, index) {
                if (index < firstDayOffset) return const SizedBox.shrink();

                final DateTime date = DateTime(
                  _currentMonth.year,
                  _currentMonth.month,
                  index - firstDayOffset + 1,
                );

                final bool isFuture = date.isAfter(_today);

                bool isSelectedStart =
                    _startDate != null && DateUtils.isSameDay(date, _startDate);
                bool isSelectedEnd =
                    _endDate != null && DateUtils.isSameDay(date, _endDate);
                bool isInRange =
                    _startDate != null &&
                    _endDate != null &&
                    date.isAfter(_startDate!) &&
                    date.isBefore(_endDate!);

                BoxDecoration? decoration;
                Color textColor = Colors.black87;

                if (isSelectedStart || isSelectedEnd) {
                  decoration = const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  );
                  textColor = Colors.white;
                } else if (isInRange) {
                  decoration = const BoxDecoration(
                    color: highlightColor,
                    shape: BoxShape.rectangle,
                  );
                }

                if (isFuture) {
                  textColor = Colors.grey.shade300;
                  decoration = null;
                }

                return GestureDetector(
                  // 🚀 [PERBAIKAN 2]: THE MAGIC WAND!
                  // Ini memaksa seluruh kotak (meskipun transparan) untuk menerima klik.
                  // Jukir tidak perlu lagi meng-klik tepat di atas font angkanya.
                  behavior: HitTestBehavior.opaque,
                  onTap: isFuture ? null : () => _handleDayTap(date),
                  child: Container(
                    decoration: decoration,
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                          fontWeight: (isSelectedStart || isSelectedEnd)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // --- TOMBOL BATAL & OKE ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'BATAL',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    if (_startDate != null && _endDate != null) {
                      Navigator.pop(
                        context,
                        DateTimeRange(start: _startDate!, end: _endDate!),
                      );
                    } else if (_startDate != null) {
                      Navigator.pop(
                        context,
                        DateTimeRange(start: _startDate!, end: _startDate!),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'OKE',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
