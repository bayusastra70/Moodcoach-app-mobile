import 'package:flutter/material.dart';
import '../services/recommendation_service.dart';
import '../models/recommendation_model.dart';

class RecommendationPage extends StatefulWidget {
  final int journalId;
  final String token;

  const RecommendationPage({
    super.key,
    required this.journalId,
    required this.token,
  });

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  late Future<List<Recommendation>> _future;
  bool _loading = true;
  List<Recommendation> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    try {
      final data = await RecommendationService.getByJournal(
        token: widget.token,
        journalId: widget.journalId,
      );
      setState(() {
        _recommendations = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading recommendations: $e')),
      );
    }
  }

  IconData _iconByType(String type) {
    switch (type) {
      case 'activity':
        return Icons.directions_walk;
      case 'social':
        return Icons.people;
      case 'reflection':
        return Icons.self_improvement;
      default:
        return Icons.lightbulb;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'activity':
        return Colors.green;
      case 'social':
        return Colors.blue;
      case 'reflection':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rekomendasi untuk Kamu"),
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
                : _recommendations.isEmpty
                ? const Center(
                  child: Text(
                    "Tidak ada rekomendasi 🌱",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _recommendations.length,
                  itemBuilder: (context, index) {
                    final rec = _recommendations[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: Icon(
                          _iconByType(rec.type),
                          color: _typeColor(rec.type),
                          size: 32,
                        ),
                        title: Text(
                          rec.text,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          rec.type.toUpperCase(),
                          style: TextStyle(color: _typeColor(rec.type)),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
