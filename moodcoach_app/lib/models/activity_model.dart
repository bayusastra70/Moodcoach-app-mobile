class Activity {
  final int? id;
  final int? userId;
  final String type;
  final int durationMinutes;
  final String? note;
  final String date;
  final String? createdAt;

  Activity({
    this.id,
    this.userId,
    required this.type,
    required this.durationMinutes,
    this.note,
    required this.date,
    this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      durationMinutes: json['duration_minutes'],
      note: json['note'],
      date: json['date'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'duration_minutes': durationMinutes,
      'note': note,
      'date': date,
    };
  }
}
