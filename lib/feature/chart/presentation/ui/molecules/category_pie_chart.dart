import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wedlist/feature/chart/domain/entities/category_spending.dart';
import 'package:wedlist/feature/chart/presentation/ui/colors/chart_palette.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({required this.data, super.key});
  final List<CategorySpending> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    final total = data.fold<double>(0, (p, e) => p + e.total);
    final palette = ChartPalette.adaptive(context);
    return AspectRatio(
      aspectRatio: 1.2, // kareye yakın; genişliğe göre yüksekliği belirler
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 32,
          sections: [
            for (var i = 0; i < data.length; i++)
              PieChartSectionData(
                color: palette[i % palette.length],
                value: data[i].total,
                title: '${((data[i].total / (total == 0 ? 1 : total)) * 100).toStringAsFixed(0)}%',
                radius: 56,
                titleStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
