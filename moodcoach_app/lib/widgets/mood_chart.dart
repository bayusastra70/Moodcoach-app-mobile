import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/daily_checkin_model.dart';

class MoodChart extends StatelessWidget {
  final List<DailyCheckin> data;

  const MoodChart({super.key, required this.data});

  int moodToScore(String mood) {
    switch (mood) {
      case "happy":
        return 3;
      case "sad":
        return 1;
      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...data]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: 1,
          maxY: 3,
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  switch (value.toInt()) {
                    case 1:
                      return const Text("😢");
                    case 2:
                      return const Text("😐");
                    case 3:
                      return const Text("😊");
                  }
                  return const SizedBox();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, _) {
                  if (value.toInt() >= sorted.length) {
                    return const SizedBox();
                  }
                  final date = sorted[value.toInt()].createdAt;
                  return Text("${date.day}/${date.month}");
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                sorted.length,
                (i) => FlSpot(
                  i.toDouble(),
                  moodToScore(sorted[i].mood).toDouble(),
                ),
              ),
              isCurved: true,
              barWidth: 3,
              color: const Color(0xFF6A11CB),
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF6A11CB).withOpacity(0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
