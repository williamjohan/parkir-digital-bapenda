import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

class BarDiagramWithLabels extends StatelessWidget {
  final List<double> weeklyIncome;

  const BarDiagramWithLabels({super.key, required this.weeklyIncome});

  String _formatLabel(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}jt';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}rb';
    }
    return value.toInt().toString();
  }

  String _formatYLabel(double value) {
    if (value == 1000000) return '>1jt';
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

    const double maxY = 1000000;

    final double step = (maxY / 4).ceilToDouble();
    final List<double> yLabels = [0, step, step * 2, step * 3, maxY];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pendapatan Mingguan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,

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
                            _formatYLabel(value),
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

                // ===== BARS =====
                barGroups: List.generate(weeklyIncome.length, (index) {
                  final isToday = index == todayIndex;

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
                    // ❌ DIHAPUS → biar tidak muncul otomatis
                    // showingTooltipIndicators: [0],
                  );
                }),

                // ===== TOOLTIP (muncul saat tap saja) =====
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
