import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JournalService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = "http://10.0.2.2:8000/api";

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

  /// =======================
  /// CREATE JOURNAL
  /// (AUTO AI PREDICTION)
  /// =======================
  Future<Map<String, dynamic>> submitJournal(
    String content,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/journals"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"content": content}),
    );

    if (response.statusCode == 201) {
      // parse json dan kembalikan
      return jsonDecode(response.body)['journal'];
    }

    throw Exception("FAILED_TO_SUBMIT_JOURNAL");
  }
}
