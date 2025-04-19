import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheduled_call/routes/app_routes.dart';

class HomeController extends GetxController {
  void goTo(String route) => Get.toNamed(route);

  Future<void> pickDateTimeAndNavigate() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final scheduledTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    // Navigate and pass the selected time to next page
    Get.toNamed(AppRoutes.selectNumber, arguments: {'scheduledTime': scheduledTime});
  }

}
