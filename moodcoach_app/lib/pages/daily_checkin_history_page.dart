import 'package:flutter/material.dart';
import '../services/daily_checkin_service.dart';
import '../models/daily_checkin_model.dart';
import '../widgets/mood_chart.dart';

class DailyCheckinHistoryPage extends StatefulWidget {
  const DailyCheckinHistoryPage({super.key});

  @override
  State<DailyCheckinHistoryPage> createState() =>
      _DailyCheckinHistoryPageState();
}

class _DailyCheckinHistoryPageState extends State<DailyCheckinHistoryPage> {
  final _service = DailyCheckinService();
  List<DailyCheckin> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await _service.getAll();
    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    setState(() {
      _history = data;
      _loading = false;
    });
  }

  String _emoji(String mood) {
    switch (mood) {
      case "happy":
        return "😊";
      case "sad":
        return "😢";
      default:
        return "😐";
    }
  }

  Color _moodColor(String mood) {
    switch (mood) {
      case "happy":
        return Colors.green;
      case "sad":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood History"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child:
            _loading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : _history.isEmpty
                ? const Center(
                  child: Text(
                    "Belum ada mood tercatat 🌱",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    /// ===== MOOD CHART =====
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Mood Trend",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            MoodChart(data: _history),
                          ],
                        ),
                      ),
                    ),

                    /// ===== HISTORY LIST =====
                    ..._history.map(
                      (item) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: Text(
                            _emoji(item.mood),
                            style: const TextStyle(fontSize: 36),
                          ),
                          title: Text(
                            item.mood.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _moodColor(item.mood),
                            ),
                          ),
                          subtitle: Text(item.note ?? "Tidak ada catatan"),
                          trailing: Text(
                            "${item.createdAt.day}-${item.createdAt.month}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
