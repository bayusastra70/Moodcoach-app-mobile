class DailyCheckin {
  final int id;
  final int userId;
  final String mood;
  final String? note;
  final DateTime createdAt;

  DailyCheckin({
    required this.id,
    required this.userId,
    required this.mood,
    this.note,
    required this.createdAt,
  });

  factory DailyCheckin.fromJson(Map<String, dynamic> json) {
    return DailyCheckin(
      id: json['id'],
      userId: json['user_id'],
      mood: json['mood'],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
