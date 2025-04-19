import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<String> loginWithDeviceId(String deviceId) async {
    final url = Uri.parse("https://sheduledbackend-production.up.railway.app/auth/device-login");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'deviceId': deviceId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['status'] ?? 'unknown';
    } else {
      throw Exception("Failed to login: ${response.body}");
    }
  }
}
