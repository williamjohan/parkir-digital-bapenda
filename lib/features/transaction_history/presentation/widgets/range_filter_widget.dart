import 'package:flutter/material.dart';
import '../../../../core/design_system/components/pb_datepicker_field.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/components/pb_timepicker_field.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class RangeFilterWidget extends StatefulWidget {
  final bool isTimeRangeShowed;

  final Function({
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
  })
  onApply;

  const RangeFilterWidget({
    super.key,
    required this.onApply,
    this.isTimeRangeShowed = true,
  });

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

  void _handleApply() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final range = _range ?? DateTimeRange(start: today, end: today);

    String finalStartTime = "";
    String finalEndTime = "";

    if (widget.isTimeRangeShowed) {
      if (_isMultipleDays) {
        finalStartTime = "00:00:00";
        finalEndTime = "23:59:59";
      } else {
        finalStartTime = _formatTime(_startTime);
        finalEndTime = _formatTime(_endTime);
      }
    }

    widget.onApply(
      startDate: _formatDate(range.start),
      endDate: _formatDate(range.end),
      startTime: finalStartTime,
      endTime: finalEndTime,
    );
  }

  Widget buildDateRangeField() {
    return DateRangeField(
      title: "Pilih Tanggal",
      onChanged: (range) {
        if (range != null) {
          final difference = range.end.difference(range.start).inDays;

          if (difference > 31) {
            PbStatusSnackbar.show(
              context,
              message: "Maksimal rentang waktu pencarian adalah 30 hari.",
              isError: true,
            );
            return;
          }

          setState(() {
            _range = range;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: widget.isTimeRangeShowed == false
          ? Row(
              crossAxisAlignment: CrossAxisAlignment
                  .end, // Menyejajarkan field dan tombol di bawah
              children: [
                Flexible(flex: 2, child: buildDateRangeField()),
                const SizedBox(width: 8),
                Flexible(
                  flex: 1,
                  child: PbPrimaryButton(
                    text: "Terapkan",
                    variant: PbButtonVariant.secondary,
                    onPressed: _handleApply,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildDateRangeField(),
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
                            setState(() => _startTime = time);
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
                            setState(() => _endTime = time);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PbPrimaryButton(
                        text: "Terapkan",
                        variant: PbButtonVariant.secondary,
                        onPressed: _handleApply,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
