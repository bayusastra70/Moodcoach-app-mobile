import 'package:flutter/material.dart';
import '../services/daily_checkin_service.dart';
import '../models/daily_checkin_model.dart';

class DailyCheckinPage extends StatefulWidget {
  const DailyCheckinPage({super.key});

  @override
  State<DailyCheckinPage> createState() => _DailyCheckinPageState();
}

class _DailyCheckinPageState extends State<DailyCheckinPage> {
  final _service = DailyCheckinService();
  final _noteController = TextEditingController();

  DailyCheckin? _todayCheckin;
  bool _submitting = false;
  String? _selectedMood;

  Future<void> _submit() async {
    if (_selectedMood == null) return;

    setState(() => _submitting = true);

    try {
      final checkin = await _service.createCheckin(
        _selectedMood!,
        _noteController.text,
      );

      if (!mounted) return;

      setState(() {
        _todayCheckin = checkin;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mood hari ini berhasil disimpan 🌱"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (e.toString().contains("ALREADY_CHECKED_IN")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kamu sudah check-in hari ini 😊")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menyimpan check-in"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Widget _moodCard({
    required String mood,
    required String emoji,
    required String label,
  }) {
    final bool selected = _selectedMood == mood;

    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF6A11CB) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? const Color(0xFF6A11CB) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Check-in")),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _todayCheckin == null ? _buildForm() : _buildResult(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How are you feeling today?",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Take a moment to check in with yourself 🌱",
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _moodCard(mood: "happy", emoji: "😊", label: "Happy"),
            _moodCard(mood: "neutral", emoji: "😐", label: "Neutral"),
            _moodCard(mood: "sad", emoji: "😢", label: "Sad"),
          ],
        ),

        const SizedBox(height: 24),

        TextField(
          controller: _noteController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Write a short note (optional)",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _selectedMood == null || _submitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6A11CB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child:
                _submitting
                    ? const CircularProgressIndicator()
                    : const Text(
                      "Submit Check-in",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Today's check-in complete 💙",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                _todayCheckin!.mood == "happy"
                    ? "😊"
                    : _todayCheckin!.mood == "sad"
                    ? "😢"
                    : "😐",
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 12),
              Text(
                _todayCheckin!.note ?? "No note added",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
