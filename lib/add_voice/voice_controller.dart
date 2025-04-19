import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/device_info_service.dart';
import '../services/voice_recording_service.dart';

class VoiceController extends GetxController {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isRecording = false.obs;
  final filePath = ''.obs;

  final VoiceRecordingService _service = VoiceRecordingService();
  String deviceId = '';

  RecorderController get recorderController => _service.controller;

  @override
  void onInit() {
    super.onInit();
    _fetchDeviceId();
  }

  void _fetchDeviceId() async {
    deviceId = await DeviceInfoService.getDeviceId();
    print("🆔 Device ID: $deviceId");
  }

  Future<void> toggleRecording() async {
    if (!isRecording.value) {
      if (!(formKey.currentState?.validate() ?? false)) return;

      filePath.value = await _service.startRecording();
      isRecording.value = true;
      print("🎙️ Started recording: ${filePath.value}");
    } else {
      await _service.stopRecording();
      isRecording.value = false;
      print("⏹️ Stopped recording");

      Get.defaultDialog(
        title: "Save Voice?",
        middleText: "Do you want to save the voice: '${nameController.text}'?",
        textConfirm: "Yes",
        textCancel: "No",
        onConfirm: () async {
          print("✅ YES clicked in confirmation dialog");

          try {
            print("🟡 Calling uploadToSupabase...");
            final url = await _service.uploadToSupabase(
              deviceId: deviceId,
              voiceName: nameController.text.trim(),
              filePath: filePath.value,
            );
            print("✅ Upload completed: $url");

            Get.back(); // close dialog
            Get.snackbar("Uploaded", "Voice uploaded successfully");

            nameController.clear();
            filePath.value = '';
          } catch (e) {
            Get.back(); // close dialog
            Get.snackbar("Error", "Failed to upload voice: ${e.toString()}");
            print("❌ Upload failed: $e");
          }
        },
        onCancel: () {
          print("❌ Cancel clicked in confirmation dialog");
          Get.back();
        },
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
