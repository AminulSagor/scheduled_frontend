import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audioplayers/audioplayers.dart';

class SelectVoiceController extends GetxController {
  final RxString selectedVoiceId = ''.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final voiceList = [
    {'id': 'v1', 'name': 'Greeting Voice', 'file': 'assets/voices/greeting.mp3'},
    {'id': 'v2', 'name': 'Reminder Voice', 'file': 'assets/voices/reminder.mp3'},
    {'id': 'v3', 'name': 'Thank You Voice', 'file': 'assets/voices/thankyou.mp3'},
  ];

  void selectVoice(String id) {
    selectedVoiceId.value = id;
  }

  void confirmSelection() {
    if (selectedVoiceId.value.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a voice");
      return;
    }

    Fluttertoast.showToast(msg: "Call Scheduled Successfully ✅");
    Get.back();
  }

  void playVoice(String filePath) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(filePath));
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
