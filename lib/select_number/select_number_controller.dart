import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectNumberController extends GetxController {
  final searchController = TextEditingController();
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  RxSet<String> selectedUserIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyUsers();
    searchController.addListener(() {
      filterUsers(searchController.text);
    });
  }

  void _loadDummyUsers() {
    allUsers = List.generate(20, (index) {
      return {
        'uid': 'user_$index',
        'name': 'User $index',
        'phone': '017000000${index.toString().padLeft(2, '0')}',
        'photoURL': '',
      };
    });
    filteredUsers = List.from(allUsers);
    update();
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers = List.from(allUsers);
    } else {
      filteredUsers = allUsers
          .where((user) =>
      user['name'].toLowerCase().contains(query.toLowerCase()) ||
          user['phone'].contains(query))
          .toList();
    }
    update();
  }

  void toggleSelection(String uid) {
    if (selectedUserIds.contains(uid)) {
      selectedUserIds.remove(uid);
    } else {
      selectedUserIds.add(uid);
    }
  }

  void proceedToVoiceSelection() {
    if (selectedUserIds.isNotEmpty) {
      Get.toNamed('/select-voice', arguments: selectedUserIds.toList());
    } else {
      Get.snackbar('No Selection', 'Please select at least one number.');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
