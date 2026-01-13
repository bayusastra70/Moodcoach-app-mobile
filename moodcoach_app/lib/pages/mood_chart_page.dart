import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/daily_checkin_service.dart';

class MoodChartPage extends StatefulWidget {
  const MoodChartPage({super.key});

  @override
  State<MoodChartPage> createState() => _MoodChartPageState();
}

class _MoodChartPageState extends State<MoodChartPage> {
  final _service = DailyCheckinService();
  Map<String, int> moodCount = {};

  @override
  void initState() {
    super.initState();
    _loadChart();
  }

  Future<void> _loadChart() async {
    final data = await _service.getAll();

    final map = {"happy": 0, "neutral": 0, "sad": 0};
    for (var d in data) {
      map[d.mood] = (map[d.mood] ?? 0) + 1;
    }

    setState(() => moodCount = map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Chart")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: moodCount["happy"]?.toDouble() ?? 0,
                title: "Happy",
                color: Colors.green,
              ),
              PieChartSectionData(
                value: moodCount["neutral"]?.toDouble() ?? 0,
                title: "Neutral",
                color: Colors.blueGrey,
              ),
              PieChartSectionData(
                value: moodCount["sad"]?.toDouble() ?? 0,
                title: "Sad",
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
