import 'package:flutter/material.dart';
import '../models/daily_checkin_model.dart';
import 'mood_chart.dart';

class MoodChartPreview extends StatelessWidget {
  final List<DailyCheckin> data;
  final VoidCallback onTap;

  const MoodChartPreview({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text("Belum ada data mood");
    }

    final recent = data.length > 7 ? data.sublist(data.length - 7) : data;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mood Trend (7 hari)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              MoodChart(data: recent),
              const SizedBox(height: 6),
              const Text(
                "Tap untuk lihat detail",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
