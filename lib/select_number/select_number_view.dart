import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'select_number_controller.dart';

class SelectNumberView extends StatelessWidget {
  const SelectNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SelectNumberController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Number', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Search by name or phone",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: GetBuilder<SelectNumberController>(
                builder: (_) => ListView.separated(
                  itemCount: controller.filteredUsers.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  addAutomaticKeepAlives: false,
                  itemBuilder: (_, index) {
                    final user = controller.filteredUsers[index];
                    return ListTile(
                      title: Text(user['name']),
                      subtitle: Text(user['phone']),
                      trailing: Obx(() {
                        final isSelected = controller.selectedUserIds.contains(user['uid']);
                        return Checkbox(
                          value: isSelected,
                          onChanged: (_) => controller.toggleSelection(user['uid']),
                        );
                      }),
                      onTap: () => controller.toggleSelection(user['uid']),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.proceedToVoiceSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: const Text("Done", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
