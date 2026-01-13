import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/mood_prediction_model.dart';

class MoodPredictionService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<String?> _getToken() async {
    return await _storage.read(key: "token");
  }

  Future<MoodPrediction?> getLatest() async {
    final token = await _getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/mood-predictions/latest"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return MoodPrediction.fromJson(jsonDecode(response.body));
    }

    return null;
  }
}
