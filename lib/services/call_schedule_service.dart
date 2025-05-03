import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CallScheduleService {
  static Future<void> scheduleCall({
    required List<String> to,
    required String audioId,
    required String callAt,
  }) async {
    final url = Uri.parse('${dotenv.env['BACKEND_URL']}/calls/schedule');

    final body = jsonEncode({
      'to': to,
      'audioId': audioId,
      'callAt': callAt,
    });

    print("🕰️ Scheduled Time (callAt): $callAt");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print("📤 POST $url");
    print("📦 Body: $body");
    print("📥 Status: ${response.statusCode}");
    print("📥 Response: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to schedule call");
    }
  }
}
