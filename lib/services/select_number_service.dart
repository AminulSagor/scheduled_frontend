import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SelectNumberService {
  static Future<List<Map<String, dynamic>>> fetchNumbers(String deviceId) async {
    final baseUrl = dotenv.env['BACKEND_URL'];
    final url = Uri.parse('$baseUrl/save-number?deviceId=$deviceId');

    final response = await http.get(url);
    print("📡 GET $url");
    print("📥 Status Code: ${response.statusCode}");
    print("📥 Body: ${response.body}");

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      if (res['status'] == 'success') {
        return List<Map<String, dynamic>>.from(res['data']).map((item) => {
          'uid': item['phoneNumber'],
          'name': item['name'] ?? 'Unknown',
          'phone': item['phoneNumber'],
        }).toList();
      } else {
        throw Exception(res['message'] ?? 'Unknown error');
      }
    } else {
      throw Exception('Failed to fetch numbers. Status: ${response.statusCode}');
    }
  }
}

