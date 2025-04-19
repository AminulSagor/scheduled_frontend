import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.call, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              'CALL MENU',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildMenuGrid(controller),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.goTo(AppRoutes.scheduledList),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  'Scheduled Call',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(HomeController controller) {
    final items = [
      {'icon': Icons.person, 'label': 'See Numbers', 'route': AppRoutes.seeNumbers},
      {'icon': Icons.phone, 'label': 'Add Number', 'route': AppRoutes.addNumber},
      {'icon': Icons.volume_up, 'label': 'See Voices', 'route': AppRoutes.seeVoice},
      {'icon': Icons.mic, 'label': 'Add Voice', 'route': AppRoutes.addVoice},
      {'icon': Icons.history, 'label': 'Call History', 'route': AppRoutes.callHistory},
      {'icon': Icons.schedule, 'label': 'Schedule Call', 'route': AppRoutes.scheduleCall},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            final route = item['route'] as String;
            if (route == AppRoutes.scheduleCall) {
              controller.pickDateTimeAndNavigate();
            } else {
              controller.goTo(route);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'] as IconData, size: 40.sp, color: Colors.black),
                SizedBox(height: 12.h),
                Text(
                  item['label'] as String,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
