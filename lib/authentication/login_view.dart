import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_controller.dart';
import '../../utils/validation_util.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login', style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/png/scheduled_call.png',
                    height: 120.h,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Welcome Back 👋",
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Login to continue",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: controller.phoneController,
                  decoration: controller.phoneInputDecoration,
                  keyboardType: TextInputType.phone,
                  validator: ValidationUtil.validatePhone,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: controller.passwordController,
                  decoration: controller.passwordInputDecoration,
                  obscureText: true,
                  validator: ValidationUtil.validatePassword,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.loginWithValidation,
                    style: controller.primaryButtonStyle,
                    child: Text('Login', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: controller.loginWithDeviceId,
                    style: controller.outlineButtonStyle,
                    child: Text(
                      'Continue with Device ID',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Center(
                  child: GestureDetector(
                    onTap: controller.openRegistration,
                    child: Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
