import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:io';

class UserService {
  final String baseUrl = "http://10.0.2.2:8000/api";
  final storage = const FlutterSecureStorage();

  // Ambil user profile dari backend
  Future<User?> getProfile(int userId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse("$baseUrl/users/$userId");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return User.fromJson(data);
    } else {
      print("Failed to get profile: ${response.body}");
    }
    return null;
  }

  // Update user profile
  Future<User?> updateProfile({
    required int userId,
    String? name,
    String? email,
    String? password,
    int? age,
    String? gender,
    File? avatarFile, // file avatar
    String? phone,
    String? address,
  }) async {
    final token = await storage.read(key: 'token');
    final uri = Uri.parse("$baseUrl/users/$userId");

    var request = http.MultipartRequest('POST', uri);
    request.fields['_method'] = 'PUT';
    request.headers['Authorization'] = 'Bearer $token';

    // Jika ada file avatar, tambahkan
    if (avatarFile != null) {
      final mimeType = lookupMimeType(avatarFile.path)!.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'avatar',
          avatarFile.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      );
    }

    // Tambahkan field lain jika tidak null
    if (name != null) request.fields['name'] = name;
    if (email != null) request.fields['email'] = email;
    if (password != null) request.fields['password'] = password;
    if (age != null) request.fields['age'] = age.toString();
    if (gender != null) request.fields['gender'] = gender;
    if (phone != null) request.fields['phone'] = phone;
    if (address != null) request.fields['address'] = address;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return User.fromJson(data);
    } else {
      print("Failed to update profile: ${response.body}");
      return null;
    }
  }
}
