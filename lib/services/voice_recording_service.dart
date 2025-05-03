import 'dart:io';
import 'dart:convert';
import 'package:record/record.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class VoiceRecordingService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;

  /// Start mono audio recording in WAV format
  Future<String> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.wav';

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw Exception("Microphone permission not granted.");
    }

    await _recorder.start(
      RecordConfig(
        encoder: AudioEncoder.wav,
        bitRate: 16000,
        sampleRate: 16000,
        numChannels: 1, // ✅ Mono
      ),
      path: filePath, // ✅ Must be passed like this
    );

    _currentPath = filePath;
    return filePath;
  }


  /// Stop the recording and return the file path
  Future<String?> stopRecording() async {
    await _recorder.stop();
    return _currentPath;
  }

  /// Upload WAV file to Supabase and send metadata to backend
  Future<String> uploadToSupabase({
    required String deviceId,
    required String voiceName,
    required String filePath,
  }) async {
    final supabase = Supabase.instance.client;
    final file = File(filePath);

    if (!file.existsSync() || file.lengthSync() == 0) {
      throw Exception("File is empty or does not exist.");
    }

    final sanitizedVoiceName =
    voiceName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    final filename =
        "${DateTime.now().millisecondsSinceEpoch}_$sanitizedVoiceName.wav";
    final path = "voices/$deviceId/$filename";

    // Upload to Supabase Storage
    await supabase.storage.from("library").upload(path, file);

    // Get public URL
    final publicUrl = supabase.storage.from("library").getPublicUrl(path);

    // Send metadata to backend
    final backendUrl = dotenv.env['BACKEND_URL'];
    final body = {
      'deviceId': deviceId,
      'voiceName': voiceName,
      'voiceUrl': publicUrl,
    };

    final response = await http.post(
      Uri.parse('$backendUrl/voice/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

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
