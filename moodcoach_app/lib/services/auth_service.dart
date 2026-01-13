import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000/api";
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // ================= REGISTER =================
  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      // Simpan token di secure storage
      final token = data['token'];
      await _storage.write(key: "token", value: token);

      // Buat User object lengkap dengan token
      final user = User.fromJson({...data['user'], 'token': token});

      // Simpan user di storage juga
      await _storage.write(key: "user", value: jsonEncode(user.toJson()));

      return user;
    }

    return null;
  }

  // ================= LOGIN =================
  Future<User?> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final token = data['token'];
      await _storage.write(key: "token", value: token);

      final user = User.fromJson({
        ...data['user'],
        'token': token, // tambahkan token ke User object
      });

      await _storage.write(key: "user", value: jsonEncode(user.toJson()));

      return user;
    }

    return null;
  }

  // ================= TOKEN =================
  Future<String?> getToken() async {
    return await _storage.read(key: "token");
  }

  Future<bool> isLoggedIn() async {
    return await _storage.read(key: "token") != null;
  }

  // ================= PROFILE =================
  Future<User?> getProfile() async {
    final token = await _storage.read(key: 'token');
    if (token == null) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final user = User.fromJson({
        ...data['user'],
        'token': token, // pastikan token masuk
      });

      // Update storage
      await _storage.write(key: 'user', value: jsonEncode(user.toJson()));

      return user;
    }

    // Jika token expired atau 401, logout
    if (response.statusCode == 401) {
      await logout();
    }

    return null;
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _storage.delete(key: "token");
    await _storage.delete(key: "user");
  }
}
