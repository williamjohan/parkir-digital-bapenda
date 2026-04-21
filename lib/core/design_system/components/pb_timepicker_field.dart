import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

class TimePickerField extends StatefulWidget {
  final String title;
  final TimeOfDay? initialTime;
  final Function(TimeOfDay?) onChanged;
  final bool enabled;

  const TimePickerField({
    super.key,
    required this.title,
    required this.onChanged,
    this.initialTime,
    this.enabled = true,
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
          enabled: widget.enabled,
          style: AppTypography.bodySemiBold.copyWith(
            color: widget.enabled
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
          controller: _controller,
          readOnly: true,
          onTap: widget.enabled ? _pickTime : null,
          decoration: InputDecoration(
            hintText: 'Pilih waktu',
            hintStyle: AppTypography.bodySemiBold.copyWith(color: Colors.white),
            suffixIcon: Icon(
              Icons.access_time,
              size: 18,
              color: widget.enabled
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.enabled
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
              ),
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
