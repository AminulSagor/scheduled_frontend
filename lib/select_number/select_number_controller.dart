import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/device_info_service.dart';
import '../../services/select_number_service.dart';

class SelectNumberController extends GetxController {
  final searchController = TextEditingController();
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  RxSet<String> selectedUserIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUsers();
    searchController.addListener(() {
      filterUsers(searchController.text);
    });
  }

  Future<void> _loadUsers() async {
    try {
      final deviceId = await DeviceInfoService.getDeviceId();
      final users = await SelectNumberService.fetchNumbers(deviceId);
      allUsers = users;
      filteredUsers = List.from(allUsers);
      update();
    } catch (e) {
      Get.snackbar('Error', 'Could not load numbers: $e');
      print("Could not load numbers: $e");
    }
  }

  void filterUsers(String query) {
    filteredUsers = query.isEmpty
        ? List.from(allUsers)
        : allUsers.where((user) =>
    user['name'].toLowerCase().contains(query.toLowerCase()) ||
        user['phone'].contains(query)).toList();
    update();
  }

  void toggleSelection(String uid) {
    selectedUserIds.contains(uid)
        ? selectedUserIds.remove(uid)
        : selectedUserIds.add(uid);
  }

  void proceedToVoiceSelection() {
    if (selectedUserIds.isEmpty) {
      Get.snackbar('No Selection', 'Please select at least one number.');
      return;
    }

    final scheduledTime = Get.arguments['scheduledTime'];

    final selectedPhoneNumbers = allUsers
        .where((user) => selectedUserIds.contains(user['uid']))
        .map((user) => user['phone'])
        .toList();

    Get.toNamed('/select-voice', arguments: {
      'selectedNumbers': selectedPhoneNumbers,
      'scheduledTime': scheduledTime,
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
