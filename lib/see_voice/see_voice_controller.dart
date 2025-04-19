import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../services/device_info_service.dart';
import '../services/see_voice_service.dart';

class SeeVoiceController extends GetxController {
  RxList<Map<String, dynamic>> voices = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;
  final player = AudioPlayer();
  RxInt currentPlayingIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    fetchVoices();

    player.playerStateStream.listen((state) {
      // Reset icon to play when audio finishes or is manually stopped
      if (state.processingState == ProcessingState.completed ||
          (!state.playing && state.processingState == ProcessingState.ready)) {
        currentPlayingIndex.value = -1;
      }
    });
  }

  Future<void> fetchVoices() async {
    try {
      isLoading.value = true;
      final deviceId = await DeviceInfoService.getDeviceId();
      final data = await SeeVoiceService.getVoices(deviceId);
      voices.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load voice messages');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> togglePlayPause(String url, int index) async {
    if (currentPlayingIndex.value == index) {
      await player.stop(); // reset playback state
      currentPlayingIndex.value = -1;
    } else {
      try {
        await player.setUrl(url);
        await player.play();
        currentPlayingIndex.value = index;
      } catch (_) {
        Get.snackbar('Error', 'Unable to play audio');
        currentPlayingIndex.value = -1;
      }
    }
  }

  Future<void> deleteVoice(String voiceName) async {
    try {
      final deviceId = await DeviceInfoService.getDeviceId();
      await SeeVoiceService.deleteVoice(deviceId, voiceName);
      Get.snackbar("Deleted", "Voice '$voiceName' deleted successfully");
      fetchVoices(); // refresh list
    } catch (e) {
      Get.snackbar("Error", "Failed to delete voice");
    }
  }


  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
