import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/validation_util.dart';
import '../../services/device_info_service.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String deviceId = '';

  @override
  void onInit() {
    super.onInit();
    _fetchDeviceId();
  }

  void _fetchDeviceId() async {
    deviceId = await DeviceInfoService.getDeviceId();
    print("Device ID: $deviceId");
  }

  void loginWithValidation() {
    if (formKey.currentState?.validate() ?? false) {
      loginWithDeviceId();
    } else {
      Get.snackbar("Invalid", "Please fill in all fields correctly");
    }
  }



  void loginWithDeviceId() async {
    if (deviceId.isEmpty) {
      Get.snackbar("Error", "Device ID not available");
      return;
    }

    try {
      final result = await AuthService.loginWithDeviceId(deviceId);

      if (result == 'logged-in' || result == 'registered') {
        Get.offAllNamed(AppRoutes.home); // ✅ Navigate to home page
      } else {
        Get.snackbar("Error", "Unexpected status: $result");
      }
    } catch (e) {
      print("Login failed: $e");
      Get.snackbar("Error", "Login failed: ${e.toString()}");
    }
  }



  void openRegistration() {
    Get.snackbar("Redirect", "Opening registration...");
    Get.toNamed("https://3.link");
  }

  // Input Decorations
  final phoneInputDecoration = InputDecoration(
    labelText: 'Phone Number',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    prefixIcon: const Icon(Icons.phone),
  );

  final passwordInputDecoration = InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    prefixIcon: const Icon(Icons.lock),
  );

  // Button Styles
  final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14),
    backgroundColor: Colors.deepPurple,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14),
    side: const BorderSide(color: Colors.deepPurple),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
