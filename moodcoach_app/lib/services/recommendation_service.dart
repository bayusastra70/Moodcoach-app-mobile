import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recommendation_model.dart';

class RecommendationService {
  static Future<List<Recommendation>> getByJournal({
    required String token,
    required int journalId,
  }) async {
    final res = await http.get(
      Uri.parse(
        'http://10.0.2.2:8000/api/recommendations?journal_id=$journalId',
      ),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Recommendation.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}
