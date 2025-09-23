import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wedlist/feature/chart/domain/entities/category_spending.dart';

class BarChartSample3 extends StatelessWidget {
  const BarChartSample3({required this.data, super.key});

  final List<CategorySpending> data;

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1.6,
      child: _BarChart(),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    final data = (context as Element).findAncestorWidgetOfExactType<BarChartSample3>()!.data;
    final maxY = (data.map((e) => e.total).fold<double>(0, (p, e) => e > p ? e : p) * 1.2).clamp(1.0, double.infinity);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: _titlesData(context, data),
        barTouchData: const BarTouchData(enabled: false),
        barGroups: _barGroups(context, data, maxY),
      ),
    );
  }

  FlTitlesData _titlesData(BuildContext context, List<CategorySpending> data) {
    return FlTitlesData(
      leftTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            final i = value.toInt();
            if (i < 0 || i >= data.length) return const SizedBox.shrink();
            final label = data[i].category;
            return SideTitleWidget(
              meta: meta,
              space: 4,
              child: Text(
                label.length > 10 ? '${label.substring(0, 10)}…' : label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _barGroups(
    BuildContext context,
    List<CategorySpending> data,
    double maxY,
  ) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final gradient = LinearGradient(
      colors: [primary, secondary],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

    return [
      for (var i = 0; i < data.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data[i].total,
              gradient: gradient,
            ),
          ],
          showingTooltipIndicators: const [0],
        ),
    ];
  }
}
