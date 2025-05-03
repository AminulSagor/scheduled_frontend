import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'voice_controller.dart';

class VoiceRecordingView extends StatelessWidget {
  const VoiceRecordingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VoiceController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("New Voice Message", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Voice Name", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    hintText: "Enter name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Name is required';
                    if (value.length < 3) return 'Enter at least 3 characters';
                    return null;
                  },
                ),
                SizedBox(height: 50.h),

                AudioWaveforms(
                  size: Size(double.infinity, 80.h),
                  recorderController: controller.recorderController,
                  waveStyle: const WaveStyle(
                    waveColor: Colors.black,
                    extendWaveform: true,
                    showMiddleLine: false,
                  ),
                ),
                SizedBox(height: 100.h),

                Obx(() => Center(
                  child: GestureDetector(
                    onTap: controller.toggleRecording,
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                      child: Center(
                        child: Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.isRecording.value ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),

                SizedBox(height: 110.h),

                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.toggleRecording,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      controller.isRecording.value ? "Stop" : "Start",
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
