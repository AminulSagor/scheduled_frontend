import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/validation_util.dart';
import '../add_number/add_number_controller.dart';

class ManualFormWidget extends StatelessWidget {
  const ManualFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddNumberController>();

    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header with icon + text
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.person_add_alt, color: Colors.white, size: 24.r),
                ),
                SizedBox(width: 12.w),
                Text(
                  "Add Manually",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            _buildLabel("Name:"),
            TextFormField(
              controller: controller.nameController,
              validator: ValidationUtil.validateName,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16.h),

            _buildLabel("Phone Number:"),
            TextFormField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              validator: ValidationUtil.validatePhone,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16.h),

            _buildLabel("Notes:"),
            TextFormField(
              controller: controller.noteController,
              validator: ValidationUtil.validateNote,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text("Save Number", style: TextStyle(fontSize: 18.sp, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        label,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}
