import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../services/device_info_service.dart';
import '../services/voice_recording_service.dart';

class VoiceController extends GetxController {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isRecording = false.obs;
  final filePath = ''.obs;

  final RecorderController recorderController = RecorderController(); // ✅ Shared controller
  late final VoiceRecordingService _service;
  String deviceId = '';

  @override
  void onInit() {
    super.onInit();
    _service = VoiceRecordingService();
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
      recorderController.reset();
      isRecording.value = true;
      print("🎙️ Started recording: ${filePath.value}");
    } else {
      await _service.stopRecording();
      recorderController.stop();
      isRecording.value = false;
      print("⏹️ Stopped recording");

      final file = File(filePath.value);
      print("📏 File size: ${file.lengthSync()} bytes");

      Get.defaultDialog(
        title: "Save Voice?",
        middleText: "Do you want to save the voice: '${nameController.text}'?",
        textConfirm: "Yes",
        textCancel: "No",
        onConfirm: () async {
          try {
            final url = await _service.uploadToSupabase(
              deviceId: deviceId,
              voiceName: nameController.text.trim(),
              filePath: filePath.value,
            );

            Get.back();
            Get.snackbar("Uploaded", "Voice uploaded successfully");

            nameController.clear();
            filePath.value = '';
            recorderController.reset();
          } catch (e) {
            Get.back();
            Get.snackbar("Error", "Failed to upload voice: ${e.toString()}");
          }
        },
        onCancel: () => Get.back(),
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    recorderController.dispose();
    super.onClose();
  }
}
