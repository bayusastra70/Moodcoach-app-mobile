class MoodPrediction {
  final int id;
  final String predictedMood;
  final double confidence;
  final DateTime createdAt;

  MoodPrediction({
    required this.id,
    required this.predictedMood,
    required this.confidence,
    required this.createdAt,
  });

  factory MoodPrediction.fromJson(Map<String, dynamic> json) {
    return MoodPrediction(
      id: json['id'],
      predictedMood: json['predicted_mood'],
      confidence: (json['confidence'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
