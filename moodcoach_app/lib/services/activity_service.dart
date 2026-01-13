import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';

class ActivityService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/activities';

  static Future<List<Activity>> getActivities({
    required String token,
    DateTime? date,
  }) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        if (date != null) 'date': date.toIso8601String().substring(0, 10),
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Activity.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  static Future<Activity> createActivity({
    required String token,
    required Activity activity,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(activity.toJson()),
    );

    if (response.statusCode == 201) {
      return Activity.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create activity');
    }
  }

  static Future<void> deleteActivity({
    required String token,
    required int id,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity');
    }
  }
}
