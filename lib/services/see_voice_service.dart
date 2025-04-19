import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SeeVoiceService {
  static Future<List<Map<String, dynamic>>> getVoices(String deviceId) async {
    final url = '${dotenv.env['BACKEND_URL']}/voice/list?deviceId=$deviceId';
    print("📡 GET $url");

    final response = await http.get(Uri.parse(url));

    print("📥 Status Code: ${response.statusCode}");
    print("📥 Body: ${response.body}");

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(res); // ✅ fix here
    } else {
      throw Exception("Failed to fetch voices");
    }
  }

  static Future<void> deleteVoice(String deviceId, String voiceName) async {
    final url = '${dotenv.env['BACKEND_URL']}/voice?deviceId=$deviceId&voiceName=$voiceName';
    final response = await http.delete(Uri.parse(url));

    print("🗑️ DELETE $url");
    print("📥 Status Code: ${response.statusCode}");
    print("📥 Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to delete voice");
    }
  }

}

