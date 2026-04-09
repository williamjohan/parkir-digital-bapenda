import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class BarDiagramWithLabels extends StatelessWidget {
  final List<double> weeklyIncome;
  final String selectedVehicleType;
  final List<String> vehicleTypes;
  final ValueChanged<String> onVehicleTypeChanged;

  const BarDiagramWithLabels({
    super.key,
    required this.weeklyIncome,
    required this.selectedVehicleType,
    required this.vehicleTypes,
    required this.onVehicleTypeChanged,
  });

  /// 🔹 FORMAT TOOLTIP (PAKAI NILAI ASLI)
  String _formatLabel(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}jt';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}rb';
    }
    return value.toInt().toString();
  }

  /// 🔹 FORMAT Y AXIS (TOP JADI >500rb)
  String _formatYLabel(double value, double maxY) {
    if (value == maxY) return '>500rb';
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}rb';
    }
    return value.toInt().toString();
  }

  String _getDayLabel(int index) {
    const days = ['SN', 'SL', 'R', 'K', 'J', 'SB', 'M'];
    return days[index];
  }

  int _getTodayIndex() {
    return DateTime.now().weekday - 1;
  }

  @override
  Widget build(BuildContext context) {
    final todayIndex = _getTodayIndex();

    /// 🔥 MAX Y FIX 500rb
    const double maxY = 500000;

    /// 🔥 STEP BIAR RAPI (0,125,250,375,500)
    final double step = maxY / 4;

    final List<double> yLabels = [0, step, step * 2, step * 3, maxY];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pendapatan Mingguan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    // Alternatif dengan PopupMenuButton (lebih customizable)
                    PopupMenuButton<String>(
                      initialValue: selectedVehicleType,
                      offset: const Offset(0, 40), // Memastikan muncul di bawah
                      constraints: BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 200,
                      ),
                      onSelected: onVehicleTypeChanged,
                      itemBuilder: (context) {
                        return vehicleTypes.map((type) {
                          return PopupMenuItem<String>(
                            value: type,
                            child: SizedBox(
                              width: 180,
                              child: Text(
                                type,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        }).toList();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedVehicleType,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, size: 20),
                        ],
                      ),
                    ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          /// 🔹 CHART
          SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,

                /// GRID
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  checkToShowHorizontalLine: (value) =>
                      yLabels.any((y) => (y - value).abs() < 0.5),
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.grey.withOpacity(0.25),
                    strokeWidth: 1,
                  ),
                ),

                borderData: FlBorderData(show: false),

                /// 🔹 TITLES
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: step,
                      getTitlesWidget: (value, meta) {
                        final isMatch = yLabels.any(
                          (y) => (y - value).abs() < 0.5,
                        );
                        if (!isMatch) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            _formatYLabel(value, maxY),
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _getDayLabel(value.toInt()),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),

                /// 🔹 BAR DATA
                barGroups: List.generate(weeklyIncome.length, (index) {
                  final isToday = index == todayIndex;

                  /// 🔥 CLAMP BIAR GA LEBIH DARI 500rb
                  final double visualHeight = weeklyIncome[index].clamp(
                    0,
                    maxY,
                  );

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: visualHeight,
                        width: 35,
                        borderRadius: BorderRadius.circular(6),
                        color: isToday
                            ? AppColors.primaryDark
                            : AppColors.primary.withOpacity(0.5),
                      ),
                    ],
                  );
                }),

                /// 🔹 TOOLTIP (PAKAI NILAI ASLI)
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 6,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final actualValue = weeklyIncome[group.x.toInt()];
                      return BarTooltipItem(
                        _formatLabel(actualValue),
                        const TextStyle(fontSize: 10, color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
