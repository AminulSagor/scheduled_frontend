import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'select_voice_controller.dart';

class SelectVoiceView extends StatelessWidget {
  const SelectVoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SelectVoiceController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Voice", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(() => Column(
          children: [
            Expanded(
              child: controller.voiceList.isEmpty
                  ? const Center(child: Text("No voices available."))
                  : ListView.separated(
                itemCount: controller.voiceList.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final voice = controller.voiceList[index];
                  final isPlaying = controller.currentPlayingIndex.value == index;
                  final icon = isPlaying ? Icons.stop : Icons.play_arrow;

                  return ListTile(
                    title: Text(voice['name'] ?? 'Unnamed'),
                    leading: Obx(() => Radio<String>(
                      value: voice['id'] ?? '',
                      groupValue: controller.selectedVoiceId.value,
                      onChanged: (val) => controller.selectVoice(val!),
                      activeColor: Colors.black,
                    )),
                    trailing: IconButton(
                      icon: Icon(icon, color: Colors.black),
                      onPressed: () {
                        final file = voice['file'];
                        if (file != null) {
                          controller.playVoice(file, index);
                        } else {
                          Fluttertoast.showToast(msg: "No voice file found.");
                        }
                      },
                    ),
                    onTap: () => controller.selectVoice(voice['id']?.toString() ?? ''),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.confirmSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: const Text("Confirm", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
