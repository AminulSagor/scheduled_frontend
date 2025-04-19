import 'dart:io';
import 'package:get/get.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/add_number_service.dart';
import '../services/device_info_service.dart';

class AddNumberController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();

  RxInt selectedTab = 0.obs;

  void switchTab(int index) {
    selectedTab.value = index;
  }

  String deviceId = '';

  @override
  void onInit() {
    super.onInit();
    _loadDeviceId();
  }

  void _loadDeviceId() async {
    deviceId = await DeviceInfoService.getDeviceId();
  }

  void saveNumber() async {
    if (formKey.currentState?.validate() ?? false) {
      if (deviceId.isEmpty) {
        Get.snackbar('Error', 'Device ID not found');
        return;
      }

      try {
        final result = await AddNumberService.saveNumber(
          deviceId: deviceId,
          name: nameController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          notes: noteController.text.trim(),
        );

        if (result == 'success') {
          Get.snackbar('Success', 'Number saved successfully');
          nameController.clear();
          phoneController.clear();
          noteController.clear();
        } else {
          Get.snackbar('Failed', 'API returned: $result');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to save number: ${e.toString()}');
      }
    }
  }

  /// Excel Upload Section
  RxList<Map<String, String>> uploadedData = <Map<String, String>>[].obs;

  Future<void> pickExcelFile() async {
    bool granted = await _requestStoragePermission();

    if (!granted) {
      Get.snackbar('Permission Denied', 'Storage or media access is required');
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result != null && result.files.single.path != null) {
      final extension = result.files.single.extension?.toLowerCase();
      if (extension != 'xls' && extension != 'xlsx') {
        Get.snackbar('Invalid File', 'Please select a valid Excel file (.xls or .xlsx)');
        return;
      }

      try {
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        if (excel.tables.isEmpty) {
          Get.snackbar('Invalid Excel', 'No readable sheet found in the Excel file');
          return;
        }

        uploadedData.clear();
        for (var table in excel.tables.keys) {
          final sheet = excel.tables[table];
          if (sheet == null) continue;

          for (var row in sheet.rows.skip(1)) {
            if (row.length >= 2) {
              String name = row[0]?.value.toString().trim() ?? '';
              String number = row[1]?.value.toString().trim() ?? '';

              // ✅ Strict BD number check: must be 11 digits, start with 01
              if (name.isNotEmpty &&
                  number.isNotEmpty &&
                  RegExp(r'^01[0-9]{9}$').hasMatch(number)) {
                uploadedData.add({'name': name, 'phone': number});
              }
            }
          }
        }

        if (uploadedData.isEmpty) {
          Get.snackbar('No Valid Entries', 'No valid name/number pairs found.');
        } else {
          Get.snackbar('Success', 'Excel file parsed successfully');
        }
      } catch (e) {
        Get.snackbar('Invalid Excel File', 'Failed to read Excel. Make sure it is not corrupted.');
        debugPrint('Excel parsing error: $e');
      }
    } else {
      Get.snackbar('Error', 'No file selected');
    }
  }



  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) return true;

      // Android 13+ check
      if (await Permission.mediaLibrary.isGranted ||
          await Permission.photos.isGranted ||
          await Permission.videos.isGranted) return true;

      final storage = await Permission.storage.request();
      final media = await Permission.mediaLibrary.request();
      final photos = await Permission.photos.request();
      final videos = await Permission.videos.request();

      return storage.isGranted || media.isGranted || photos.isGranted || videos.isGranted;
    }
    return true;
  }


  Future<bool> _isAndroid13OrAbove() async {
    return Platform.isAndroid && (await _getAndroidVersion()) >= 33;
  }

  Future<int> _getAndroidVersion() async {
    try {
      var release = Platform.version;
      var match = RegExp(r'Android (\d+)').firstMatch(release);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
    } catch (_) {}
    return 0; // fallback
  }


  void confirmUpload() async {
    if (uploadedData.isEmpty) {
      Get.snackbar('Error', 'No data to upload');
      return;
    }

    if (deviceId.isEmpty) {
      Get.snackbar('Error', 'Device ID not found');
      return;
    }

    try {
      final results = await AddNumberService.saveBatch(
        deviceId: deviceId,
        entries: uploadedData,
      );

      final successCount = results.where((r) => r['status'] == 'success').length;
      final duplicateCount = results.where((r) => r['status'] == 'duplicate').length;

      Get.snackbar(
        'Upload Complete',
        '$successCount saved, $duplicateCount skipped (duplicates)',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );

      uploadedData.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload: ${e.toString()}');
    }
  }


  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
