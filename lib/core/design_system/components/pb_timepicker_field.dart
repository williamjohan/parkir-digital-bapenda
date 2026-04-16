import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

class TimePickerField extends StatefulWidget {
  final String title;
  final TimeOfDay? initialTime;
  final Function(TimeOfDay?) onChanged;

  const TimePickerField({
    super.key,
    required this.title,
    required this.onChanged,
    this.initialTime,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  TimeOfDay? _selectedTime;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    // ✅ pakai initial atau fallback
    _selectedTime = widget.initialTime ?? TimeOfDay.now();

    _controller = TextEditingController(text: _formatTime(_selectedTime!));
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime!,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _formatTime(picked);
      });

      widget.onChanged(picked);
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
          style: AppTypography.bodySemiBold.copyWith(color: Colors.white),
          controller: _controller,
          readOnly: true,
          onTap: _pickTime,
          decoration: InputDecoration(
            hintText: 'Pilih waktu',
            hintStyle: AppTypography.bodySemiBold.copyWith(color: Colors.white),
            suffixIcon: const Icon(
              Icons.access_time,
              size: 18,
              color: Colors.white,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
