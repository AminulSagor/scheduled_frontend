import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import '../../services/device_info_service.dart';
import '../../services/select_voice_service.dart';
import '../../services/call_schedule_service.dart';

class SelectVoiceController extends GetxController {
  final RxString selectedVoiceId = ''.obs;
  final AudioPlayer player = AudioPlayer();
  final RxList<Map<String, dynamic>> voiceList = <Map<String, dynamic>>[].obs;
  RxInt currentPlayingIndex = (-1).obs;

  late final List<String> selectedNumbers;
  late final DateTime scheduledTime;

  @override
  void onInit() {
    super.onInit();

    selectedNumbers = List<String>.from(Get.arguments['selectedNumbers']);
    scheduledTime = Get.arguments['scheduledTime'];

    _loadVoices();

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed ||
          (!state.playing && state.processingState == ProcessingState.ready)) {
        currentPlayingIndex.value = -1;
      }
    });
  }

  Future<void> _loadVoices() async {
    try {
      final deviceId = await DeviceInfoService.getDeviceId();
      final voices = await VoiceService.getVoices(deviceId);

      voiceList.assignAll(
        voices
            .where((voice) =>
        voice is Map<String, dynamic> &&
            voice['voiceUrl'] != null &&
            voice['voiceName'] != null)
            .map<Map<String, dynamic>>((voice) {
          final id = voice['id']?.toString() ?? '';
          final name = voice['voiceName'] ?? 'Unnamed';
          final file = voice['voiceUrl'];
          return {
            'id': id,
            'name': name,
            'file': file,
          };
        }).toList(),
      );
    } catch (e, stack) {
      Fluttertoast.showToast(msg: "Failed to load voices: $e");
      print("❌ Error loading voices: $e");
      print("📛 Stacktrace: $stack");
    }
  }

  void selectVoice(String id) {
    selectedVoiceId.value = id;
  }

  Future<void> confirmSelection() async {
    if (selectedVoiceId.value.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a voice");
      return;
    }

    try {
      await CallScheduleService.scheduleCall(
        to: selectedNumbers,
        audioId: selectedVoiceId.value,
        callAt: scheduledTime.toIso8601String(),
      );

      Fluttertoast.showToast(msg: "Call Scheduled Successfully ✅");
      Get.offAllNamed('/home');
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to schedule call: $e");
    }
  }

  Future<void> playVoice(String url, int index) async {
    if (currentPlayingIndex.value == index) {
      await player.stop();
      currentPlayingIndex.value = -1;
    } else {
      try {
        await player.setUrl(url);
        await player.play();
        currentPlayingIndex.value = index;
      } catch (_) {
        Fluttertoast.showToast(msg: "Unable to play audio");
        currentPlayingIndex.value = -1;
      }
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
