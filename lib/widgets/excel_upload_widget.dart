import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../add_number/add_number_controller.dart';

class ExcelUploadWidget extends StatelessWidget {
  const ExcelUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddNumberController>();

    return Column(
      children: [
        Text(
          "Add a number from an Excel file on your device",
          style: TextStyle(fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.pickExcelFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text("Upload File", style: TextStyle(fontSize: 16.sp, color: Colors.black)),
          ),
        ),
        SizedBox(height: 12.h),
        Text("Only .xls and .xlsx files allowed", style: TextStyle(color: Colors.grey)),
        SizedBox(height: 24.h),
        Obx(() {
          final list = controller.uploadedData;
          if (list.isEmpty) return const SizedBox();
          return Expanded(
            child: Column(
              children: [
                Text("Preview (${list.length} numbers)", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 12.h),
                Expanded(
                  child: ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final item = list[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text(item['name'] ?? ''),
                        subtitle: Text(item['phone'] ?? ''),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.confirmUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text("Confirm Upload", style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                  ),
                )
              ],
            ),
          );
        }),
      ],
    );
  }
}
