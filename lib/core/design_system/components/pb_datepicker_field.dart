import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../tokens/app_typography.dart';
import 'pb_calendar_range_picker.dart';

// IMPORT punyamu sendiri
// import 'pb_calendar_range_picker.dart';

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

    // ✅ default ke hari ini
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
        TextField(
          controller: _controller,
          readOnly: true,
          onTap: _openPicker,
          style: AppTypography.bodySemiBold.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Pilih rentang tanggal',
            hintStyle: AppTypography.bodySemiBold.copyWith(color: Colors.white),
            suffixIcon: const Icon(
              Icons.calendar_today,
              size: 18,
              color: Colors.white,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
