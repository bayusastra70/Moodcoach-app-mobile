class Recommendation {
  final int id;
  final String text;
  final String type;

  Recommendation({required this.id, required this.text, required this.type});

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'],
      text: json['recommendation_text'],
      type: json['type'],
    );
  }
}
