import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        child: Column(
          children: [
            /// Voice list
            Expanded(
              child: ListView.separated(
                itemCount: controller.voiceList.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (_, index) {
                  final voice = controller.voiceList[index];
                  return ListTile(
                    title: Text(voice['name']!),
                    leading: Obx(() => Radio<String>(
                      value: voice['id']!,
                      groupValue: controller.selectedVoiceId.value,
                      onChanged: (val) => controller.selectVoice(val!),
                      activeColor: Colors.black,
                    )),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.black),
                      onPressed: () => controller.playVoice(voice['file']!),
                    ),
                    onTap: () => controller.selectVoice(voice['id']!),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),

            /// Confirm button
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
        ),
      ),
    );
  }
}
