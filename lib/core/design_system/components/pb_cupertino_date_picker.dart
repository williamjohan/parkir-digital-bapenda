import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tokens/app_colors.dart'; // Sesuaikan
import '../tokens/app_typography.dart'; // Sesuaikan
import 'pb_primary_button.dart';

class PbCupertinoDatePicker {
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    int startYear = 2020,
    int endYear = 2100,
  }) {
    DateTime selectedDate = initialDate ?? DateTime.now();
    int selectedDay = selectedDate.day;
    int selectedMonth = selectedDate.month;
    int selectedYear = selectedDate.year;

    const double itemHeight = 48;

    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Pilih Tanggal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height:
                        itemHeight * 3, // 3 item terlihat (seperti roda gigi)
                    child: Row(
                      children: [
                        /// DAY
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: itemHeight,
                            useMagnifier: true,
                            magnification: 1.1,
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedDay - 1,
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() => selectedDay = index + 1);
                            },
                            children: List.generate(
                              daysInMonth,
                              (index) => Center(child: Text("${index + 1}")),
                            ),
                          ),
                        ),

                        /// MONTH
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: itemHeight,
                            useMagnifier: true,
                            magnification: 1.1,
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedMonth - 1,
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedMonth = index + 1;
                                int maxDay = DateTime(
                                  selectedYear,
                                  selectedMonth + 1,
                                  0,
                                ).day;
                                if (selectedDay > maxDay) selectedDay = maxDay;
                              });
                            },
                            children: List.generate(
                              12,
                              (index) => Center(child: Text("${index + 1}")),
                            ),
                          ),
                        ),

                        /// YEAR
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: itemHeight,
                            useMagnifier: true,
                            magnification: 1.1,
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedYear - startYear,
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedYear = startYear + index;
                                int maxDay = DateTime(
                                  selectedYear,
                                  selectedMonth + 1,
                                  0,
                                ).day;
                                if (selectedDay > maxDay) selectedDay = maxDay;
                              });
                            },
                            children: List.generate(
                              endYear - startYear + 1,
                              (index) =>
                                  Center(child: Text("${startYear + index}")),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  PbPrimaryButton(
                    text: "Konfirmasi Tanggal",
                    isLoading: false,
                    onPressed: () => Navigator.pop(
                      context,
                      DateTime(selectedYear, selectedMonth, selectedDay),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
