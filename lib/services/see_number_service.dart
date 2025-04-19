import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SeeNumberService {
  static Future<List<Map<String, dynamic>>> getNumbers(String deviceId) async {
    final url = '${dotenv.env['BACKEND_URL']}/save-number?deviceId=$deviceId';
    print("📡 GET $url");

    final response = await http.get(Uri.parse(url));

    print("📥 Status Code: ${response.statusCode}");
    print("📥 Body: ${response.body}");

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      if (res['status'] == 'success') {
        return List<Map<String, dynamic>>.from(res['data']);
      } else {
        throw Exception(res['message']);
      }
    } else {
      throw Exception("Failed to fetch numbers");
    }
  }

  static Future<void> deleteNumber(String deviceId, String phoneNumber) async {
    final url = '${dotenv.env['BACKEND_URL']}/save-number?deviceId=$deviceId&phoneNumber=$phoneNumber';
    final response = await http.delete(Uri.parse(url));

    print("🗑️ DELETE $url");
    print("📥 Status Code: ${response.statusCode}");
    print("📥 Body: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to delete number');
    }
  }


}
