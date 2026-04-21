import 'package:flutter/material.dart';

import '../../../../core/design_system/components/pb_datepicker_field.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/components/pb_timepicker_field.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class RangeFilterWidget extends StatefulWidget {
  final Function({
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
  })
  onApply;

  const RangeFilterWidget({super.key, required this.onApply});

  @override
  State<RangeFilterWidget> createState() => _RangeFilterWidgetState();
}

class _RangeFilterWidgetState extends State<RangeFilterWidget> {
  DateTimeRange? _range;
  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 59);

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  String _formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}:00";
  }

  bool get _isMultipleDays {
    if (_range == null) return false;

    return _range!.start != _range!.end;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          DateRangeField(
            title: "Pilih Tanggal",
            onChanged: (range) {
              setState(() {
                _range = range;
              });
            },
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TimePickerField(
                  title: "Jam Mulai",
                  initialTime: _startTime,
                  enabled: !_isMultipleDays,
                  onChanged: (time) {
                    if (time != null) {
                      _startTime = time;
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: TimePickerField(
                  title: "Jam Selesai",
                  initialTime: _endTime,
                  enabled: !_isMultipleDays,
                  onChanged: (time) {
                    if (time != null) {
                      _endTime = time;
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: PbPrimaryButton(
                  text: "Terapkan",
                  variant: PbButtonVariant.secondary,
                  onPressed: () {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);

                    final range =
                        _range ?? DateTimeRange(start: today, end: today);

                    widget.onApply(
                      startDate: _formatDate(range.start),
                      endDate: _formatDate(range.end),
                      startTime: _formatTime(_startTime),
                      endTime: _formatTime(_endTime),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
