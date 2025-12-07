import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class CategoryPieChart extends StatelessWidget {
  final List<Transaction> transactions;

  const CategoryPieChart({
    required this.transactions,
    super.key,
  });

  static const List<Color> _chartColors = [
    Color(0xFF579C79),
    Color(0xFF4A90D9),
    Color(0xFFE57373),
    Color(0xFFFFB74D),
    Color(0xFF9575CD),
    Color(0xFF4DB6AC),
    Color(0xFFFF8A65),
    Color(0xFFA1887F),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter to expenses only for current month
    final now = DateTime.now();
    final currentMonthExpenses = transactions.where((t) =>
        t.type == TransactionType.expense &&
        t.date.year == now.year &&
        t.date.month == now.month).toList();

    if (currentMonthExpenses.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No expenses this month',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Group by category
    final categoryTotals = <String, double>{};
    for (final t in currentMonthExpenses) {
      final category = t.category.isNotEmpty ? t.category : 'Uncategorized';
      categoryTotals[category] = (categoryTotals[category] ?? 0) + t.amount;
    }

    // Sort by amount descending
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalExpenses = sortedCategories.fold<double>(
        0, (sum, entry) => sum + entry.value);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: sortedCategories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value.key;
                final amount = entry.value.value;
                final percentage = (amount / totalExpenses) * 100;

                return PieChartSectionData(
                  color: _chartColors[index % _chartColors.length],
                  value: amount,
                  title: '${percentage.toStringAsFixed(0)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: sortedCategories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value.key;
            final amount = entry.value.value;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _chartColors[index % _chartColors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$category (\$${amount.toStringAsFixed(0)})',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
