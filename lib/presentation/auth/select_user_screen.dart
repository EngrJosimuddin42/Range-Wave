import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/controller/signup_controller.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/gen/assets.gen.dart';

class SelectUserScreen extends StatelessWidget {
  SelectUserScreen({super.key});

  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Assets.images.repairMan.image(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Positioned(
            left: 55.w,
            right: 55.w,
            top: 65.h,
            child: Column(
              children: [
                Assets.images.appLogo.image(
                  width: 88.w,
                  height: 88.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10.h),
                Text(
                  'Fast. Trusted. Local Mechanics.',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTernary,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 120.h,
            left: 18.w,
            right: 18.w,
            child: PrimaryButton(
              text: 'User',
              backgroundColor: AppColors.primary,
              onTap: () {
                controller.selectedRole.value = 'customer';
                AppHelper.instance.setRole('customer');
                Get.toNamed(AppRoutes.signIn);
              },
            ),
          ),

          Positioned(
            bottom: 54.h,
            left: 18.w,
            right: 18.w,
            child: PrimaryButton(
              text: 'Mechanic',
              onTap: () {
                controller.selectedRole.value = 'mechanic';
                AppHelper.instance.setRole('mechanic');
                Get.toNamed(AppRoutes.signIn);
              },
            ),
          ),
        ],
      ),
    );
  }
}
