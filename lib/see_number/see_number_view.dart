import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'see_number_controller.dart';

class SeeNumberView extends StatelessWidget {
  const SeeNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SeeNumberController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Numbers", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.numbers.isEmpty) {
          return const Center(child: Text("No numbers found"));
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.numbers.length,
          separatorBuilder: (_, __) => Divider(height: 1),
          itemBuilder: (_, i) {
            final item = controller.numbers[i];
            return GestureDetector(
              onLongPress: () => _showDeleteDialog(context, controller, item['phoneNumber']),
              child: ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(item['name']),
                subtitle: Text(item['phoneNumber']),
                trailing: Text(item['notes'] ?? '', style: TextStyle(color: Colors.grey)),
              ),
            );
          },
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, SeeNumberController controller, String phoneNumber) {
    Get.defaultDialog(
      title: "Delete Number",
      middleText: "Are you sure you want to delete this number?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.deleteNumber(phoneNumber);
      },
      onCancel: () => Get.back(),
    );
  }
}
