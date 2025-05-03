import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceService {
  static Future<List<Map<String, dynamic>>> getVoices(String deviceId) async {
    final url = '${dotenv.env['BACKEND_URL']}/voice/list?deviceId=$deviceId';
    final response = await http.get(Uri.parse(url));

    print("📥 Status Code: ${response.statusCode}");
    print("📥 Body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        // Ensure each element is a Map
        return decoded
            .whereType<Map<String, dynamic>>()
            .toList();
      } else if (decoded is Map && decoded.containsKey('data')) {
        final data = decoded['data'];
        if (data is List) {
          return data.whereType<Map<String, dynamic>>().toList();
        }
      }

      throw Exception("Unexpected voice data format");
    } else {
      throw Exception("Failed to load voices");
    }
  }
}
