import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../tokens/app_typography.dart';
import 'pb_calendar_range_picker.dart';

class DateRangeField extends StatefulWidget {
  final String title;
  final DateTimeRange? initialRange;
  final Function(DateTimeRange?) onChanged;

  const DateRangeField({
    super.key,
    required this.title,
    required this.onChanged,
    this.initialRange,
  });

  @override
  State<DateRangeField> createState() => _DateRangeFieldState();
}

class _DateRangeFieldState extends State<DateRangeField> {
  DateTimeRange? _selectedRange;
  late TextEditingController _controller;

  final DateFormat _formatter = DateFormat('dd MMM yyyy', 'id_ID');

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _selectedRange =
        widget.initialRange ?? DateTimeRange(start: today, end: today);
    _controller = TextEditingController(text: _formatRange(_selectedRange!));
  }

  String _formatRange(DateTimeRange range) {
    final start = _formatter.format(range.start);
    final end = _formatter.format(range.end);

    if (start == end) return start;
    return "$start - $end";
  }

  Future<void> _openPicker() async {
    final result = await PbCalendarRangePicker.show(
      context: context,
      initialStartDate: _selectedRange?.start,
      initialEndDate: _selectedRange?.end,
    );

    if (result != null) {
      setState(() {
        _selectedRange = result;
        _controller.text = _formatRange(result);
      });

      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTypography.caption.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 6),
        // 🚀 AREA SENTUH LEBAR: InkWell + AbsorbPointer
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _openPicker,
            child: AbsorbPointer(
              child: TextField(
                controller: _controller,
                readOnly: true,
                style: AppTypography.bodySemiBold.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Pilih rentang tanggal',
                  hintStyle: AppTypography.bodySemiBold.copyWith(
                    color: Colors.white,
                  ),
                  // 🚀 PERBAIKAN: Ikon diperbesar ke 24
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    size: 24,
                    color: Colors.white,
                  ),
                  // 🚀 PERBAIKAN: Padding 16 untuk touch area yang lega
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
