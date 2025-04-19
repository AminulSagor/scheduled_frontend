import 'package:http/http.dart' as http;
import 'dart:convert';

class AddNumberService {
  static const _baseUrl = 'https://sheduledbackend-production.up.railway.app/save-number';

  static Future<String> saveNumber({
    required String deviceId,
    required String name,
    required String phoneNumber,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'deviceId': deviceId,
        'name': name,
        'phoneNumber': phoneNumber,
        'notes': notes ?? '',
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['status'] ?? 'unknown';
    } else {
      throw Exception('Failed to save number: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> saveBatch({
    required String deviceId,
    required List<Map<String, String>> entries,
  }) async {
    final payload = entries.map((e) => {
      'deviceId': deviceId,
      'name': e['name'],
      'phoneNumber': e['phone'],
    }).toList();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(json['results']);
    } else {
      throw Exception('Failed to upload batch: ${response.body}');
    }
  }
}
