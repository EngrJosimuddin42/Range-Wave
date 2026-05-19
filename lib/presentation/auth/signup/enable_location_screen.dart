import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:range_wave/controller/enable_location_controller.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/gen/assets.gen.dart';

class EnableLocationScreen extends StatelessWidget {
  EnableLocationScreen({super.key});

  final EnableLocationController controller = Get.put(
    EnableLocationController(),
  );

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showCustomToast(
        text: 'Location services are disabled. Please enable them.',
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showCustomToast(text: 'Location permission denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showCustomToast(
        text:
            'Location permission permanently denied. Please enable it from settings.',
      );
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Location timeout or error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopLogo(),
            SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _imageTitleSection(),
                  SizedBox(height: 12.h),
                  Text(
                    'We use your location to send mechanic to your exact spot',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 100.h),
                  Obx(() {
                    return PrimaryButton(
                      text: 'Allow',
                      loading: controller.isLoading.value,
                      backgroundColor: AppColors.primary,
                      onTap: () async {
                        debugPrint('Allow button pressed');
                        try {
                          controller.isLoading.value = true;
                          final position = await _getCurrentLocation();
                          debugPrint('Position result: $position');

                          if (position != null) {
                            debugPrint(
                              'Calling setCurrentLocation in background',
                            );
                            controller.setCurrentLocation(
                              position.latitude,
                              position.longitude,
                            );
                          }
                        } catch (e) {
                          debugPrint('Location error in onTap: $e');
                        } finally {
                          controller.isLoading.value = false;
                        }

                        debugPrint('Checking role for navigation...');
                        final role = await AppHelper.instance.getRole();
                        debugPrint('Role from prefs: $role');

                        if (role == 'customer') {
                          debugPrint('Navigating to AddCar');
                          Get.offAllNamed(AppRoutes.addCar);
                        } else if (role == 'mechanic') {
                          debugPrint('Navigating to MechanicEditProfile');
                          Get.offAllNamed(AppRoutes.mechanicEditProfile);
                        } else {
                          debugPrint(
                            'Role is null or unknown: $role. Falling back to selectUser',
                          );
                          Get.offAllNamed(AppRoutes.selectUser);
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _imageTitleSection() {
  return Column(
    children: [
      Align(
        alignment: Alignment.center,
        child: Assets.images.map.image(
          width: 124.w,
          height: 124.w,
          fit: BoxFit.contain,
        ),
      ),
      SizedBox(height: 32.h),
      Align(
        alignment: Alignment.center,
        child: Text(
          'Enable Location',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}
