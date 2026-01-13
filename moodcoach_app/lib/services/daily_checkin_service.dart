import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/daily_checkin_model.dart';

class DailyCheckinService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = "http://10.0.2.2:8000/api";

  // =======================
  // TOKEN & HEADERS
  // =======================
  Future<String?> _getToken() async {
    return await _storage.read(key: "token");
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  // =======================
  // GET TODAY CHECK-IN
  // =======================
  Future<DailyCheckin?> getToday() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/daily-checkins/today"),
            headers: await _headers(),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['result'] == null
            ? null
            : DailyCheckin.fromJson(body['result']);
      }

      throw Exception("FAILED_TO_LOAD_TODAY_CHECKIN");
    } catch (e) {
      rethrow;
    }
  }

  // =======================
  // CREATE CHECK-IN (POST)
  // =======================
  Future<DailyCheckin> createCheckin(String mood, String note) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/daily-checkins"),
            headers: await _headers(),
            body: jsonEncode({"mood": mood, "note": note}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return DailyCheckin.fromJson(jsonDecode(response.body));
      }

      if (response.statusCode == 409) {
        throw Exception("ALREADY_CHECKED_IN");
      }

      throw Exception("FAILED_TO_SUBMIT_CHECKIN");
    } catch (e) {
      rethrow;
    }
  }

  // =======================
  // GET CHECK-IN HISTORY
  // =======================
  Future<List<DailyCheckin>> getAll() async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/daily-checkins"), headers: await _headers())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['result'];
        return data.map((e) => DailyCheckin.fromJson(e)).toList();
      }

      throw Exception("FAILED_TO_LOAD_HISTORY");
    } catch (e) {
      rethrow;
    }
  }
}
