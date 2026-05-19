import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../gen/assets.gen.dart';

class PaymentSuccessfulScreen extends StatelessWidget {
  const PaymentSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.paymentSuccess.image(),
            SizedBox(height: 32.h),
            Text(
              'Your Payment has been successfully paid.',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 50.h),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'Later',
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                    borderColor: AppColors.textPrimary,
                    onTap: (){
                      Get.toNamed(AppRoutes.userBottomNav);
                    },
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: PrimaryButton(
                    text: 'Rate',
                    backgroundColor: AppColors.primary,
                    onTap: () {
                      Get.toNamed(AppRoutes.rateMechanic);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
