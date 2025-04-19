import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoiceRecordingService {
  final RecorderController recorderController = RecorderController();

  Future<String> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';
    await recorderController.record(path: filePath);
    return filePath;
  }

  Future<void> stopRecording() async {
    await recorderController.stop();
  }

  RecorderController get controller => recorderController;

  Future<String> uploadToSupabase({
    required String deviceId,
    required String voiceName,
    required String filePath,
  }) async {
    final supabase = Supabase.instance.client;
    final file = File(filePath);
    final filename = "${DateTime.now().millisecondsSinceEpoch}_${voiceName.replaceAll(' ', '_')}.aac";
    final path = "voices/$deviceId/$filename";

    // Upload to Supabase Storage
    await supabase.storage
        .from("library app")
        .upload(path, file);

    // Get public URL
    final publicUrl = supabase.storage
        .from("library app")
        .getPublicUrl(path);


    // Send metadata to backend
    final backendUrl = dotenv.env['BACKEND_URL'];
    final body = {
      'deviceId': deviceId,
      'voiceName': voiceName,
      'voiceUrl': publicUrl,
    };

    print("📡 Sending metadata to backend:");
    print("POST $backendUrl/voice/save");
    print("Payload: $body");

    final response = await http.post(
      Uri.parse('$backendUrl/voice/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print("📥 Response: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final res = jsonDecode(response.body);
      if (res['status'] == 'success') {
        return publicUrl;
      } else {
        throw Exception(res['message']);
      }
    } else {
      throw Exception("Failed to save voice metadata");
    }

  }
}
