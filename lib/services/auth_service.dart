import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://192.168.18.11:8000";

  static Future<String?> login(String username, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/user/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": username,
          "password": password,
        }),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body)["access_token"];
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  // Verify token function
  static Future<bool> verifyToken(String token) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/user/verify_token"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body) as bool;
      }
    } catch (e) {
      return false;
    }

    return false;
  }
}