import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/device_info_service.dart';
import '../services/see_number_service.dart';

class SeeNumberController extends GetxController {
  RxList<Map<String, dynamic>> numbers = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNumbers();
  }

  Future<void> fetchNumbers() async {
    try {
      isLoading.value = true;
      final deviceId = await DeviceInfoService.getDeviceId();
      final data = await SeeNumberService.getNumbers(deviceId);
      numbers.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load numbers');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNumber(String phoneNumber) async {
    try {
      final deviceId = await DeviceInfoService.getDeviceId();
      await SeeNumberService.deleteNumber(deviceId, phoneNumber);
      Get.snackbar('Deleted', 'Number removed successfully');
      fetchNumbers(); // ✅ refresh after delete
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete number');
    }
  }

}
