import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'see_voice_controller.dart';

class SeeVoiceView extends StatelessWidget {
  const SeeVoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SeeVoiceController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Messages", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.voices.isEmpty) {
          return const Center(child: Text("No voice messages found"));
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.voices.length,
          separatorBuilder: (_, __) => Divider(height: 1),
          itemBuilder: (_, i) {
            final item = controller.voices[i];
            return Obx(() => ListTile(
              leading: Icon(
                controller.currentPlayingIndex.value == i
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_outline,
                size: 28,
              ),
              title: Text(item['voiceName'] ?? 'Unknown'),
              onTap: () => controller.togglePlayPause(item['voiceUrl'], i),
              onLongPress: () =>
                  _showDeleteDialog(context, controller, item['voiceName']),
            ));
          },
        );
      }),
    );
  }

  void _showDeleteDialog(
      BuildContext context, SeeVoiceController controller, String voiceName) {
    Get.defaultDialog(
      title: "Delete Voice",
      middleText: "Are you sure you want to delete '$voiceName'?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.deleteVoice(voiceName);
      },
      onCancel: () => Get.back(),
    );
  }
}
