import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/excel_upload_widget.dart';
import '../widgets/manual_form_widget.dart';
import 'add_number_controller.dart';


class AddNumberView extends StatelessWidget {
  const AddNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddNumberController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Number", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Obx(() => Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [
                controller.selectedTab.value == 0,
                controller.selectedTab.value == 1,
              ],
              onPressed: controller.switchTab,
              borderRadius: BorderRadius.circular(12.r),
              constraints: BoxConstraints(minWidth: 160.w, minHeight: 48.h),
              selectedColor: Colors.white,
              fillColor: Colors.black,
              color: Colors.black,
              children: const [Text("Manually"), Text("Excel")],
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: controller.selectedTab.value == 0
                  ? const ManualFormWidget()
                  : const ExcelUploadWidget(),
            ),
          ],
        ),
      )),
    );
  }
}
