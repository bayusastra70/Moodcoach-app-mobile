import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../models/mood_prediction_model.dart';

import '../services/mood_prediction_service.dart';

import 'user_profile_page.dart';
import 'daily_checkin_page.dart';
import 'journal_page.dart';
import 'activity_page.dart';

class DashboardPage extends StatefulWidget {
  final User user;
  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _moodPredictionService = MoodPredictionService();
  late Future<MoodPrediction?> _aiInsightFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _aiInsightFuture = _moodPredictionService.getLatest();
  }

  /// ================= NAVIGATION =================
  Future<void> _openDailyCheckin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DailyCheckinPage()),
    );
    if (result == true) setState(_refresh);
  }

  Future<void> _openJournal() async {
    if (widget.user.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User token not available!")),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JournalPage(token: widget.user.token!), // kirim token
      ),
    );
    if (result == true) setState(_refresh);
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserProfilePage(user: widget.user)),
    );
  }

  void _openActivity() {
    if (widget.user.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User token not available!")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityPage(token: widget.user.token!), // kirim token
      ),
    );
  }

  String _emoji(String mood) {
    switch (mood) {
      case "good":
        return "😊";
      case "bad":
        return "😔";
      default:
        return "😐";
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "MoodCoach",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white),
                    onPressed: _openProfile,
                  ),
                ],
              ),
            ),
          ),

          /// ================= CONTENT =================
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -16), // 🔥 overlap ke gradient
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ListView(
                  children: [
                    /// ========== TODAY ACTIVITY ==========
                    const Text(
                      "Today Activity",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.directions_run,
                              size: 36,
                              color: Color(0xFF6A11CB),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your Activities Today",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Log mindfulness, physical, or social activities",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _openActivity,
                              child: const Text("Open"),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ========== AI INSIGHT ==========
                    const Text(
                      "AI Insight",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    FutureBuilder<MoodPrediction?>(
                      future: _aiInsightFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Text(
                            "Write a journal to see AI analysis 🌱",
                            style: TextStyle(color: Colors.black54),
                          );
                        }

                        final data = snapshot.data!;

                        return Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Text(
                                  _emoji(data.predictedMood),
                                  style: const TextStyle(fontSize: 36),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "AI detected mood: ${data.predictedMood}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Confidence ${(data.confidence * 100).toStringAsFixed(1)}%",
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    /// ========== QUICK ACTIONS ==========
                    const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        _actionCard(
                          icon: Icons.check_circle,
                          title: "Daily Check-in",
                          subtitle: "Mood hari ini",
                          color: const Color(0xFF6A11CB),
                          onTap: _openDailyCheckin,
                        ),
                        _actionCard(
                          icon: Icons.edit_note,
                          title: "Write Journal",
                          subtitle: "Curhat & AI analyze",
                          color: Colors.orange,
                          onTap: _openJournal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= ACTION CARD =================
  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 68) / 2,
        height: 120, // 🔥 diperkecil
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
