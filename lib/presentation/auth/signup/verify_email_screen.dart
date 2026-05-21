import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:range_wave/controller/signup_controller.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/core/utils/custom_toast.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final SignupController controller = Get.find<SignupController>();
  String otp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            AppTopLogo(),
            SizedBox(height: 100.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verify your email',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Enter the OTP sent to your email',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  OtpTextField(
                    numberOfFields: 6,
                    cursorColor: AppColors.textPrimary,
                    fillColor: AppColors.buttonTextColor,
                    filled: true,
                    focusedBorderColor: AppColors.primary,
                    enabledBorderColor: AppColors.buttonTextColor,
                    showFieldAsBox: true,
                    borderRadius: BorderRadius.circular(12.r),
                    fieldWidth: 45.w,
                    borderWidth: 1.5,
                    fieldHeight: 55.w,
                    textStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onCodeChanged: (code) {},
                    onSubmit: (code) {
                      otp = code;
                    },
                  ),
                  SizedBox(height: 50.h),
                  Obx(() {
                    return PrimaryButton(
                      text: 'Verify',
                      loading: controller.isLoading.value,
                      backgroundColor: AppColors.primary,
                      onTap: () async {
                        if (otp.isEmpty || otp.length < 6) {
                          showCustomToast(text: 'Please enter OTP');
                          return;
                        }
                        final okay = await controller.verifyEmail(otp);
                        if (okay) {
                          Get.offAllNamed(AppRoutes.enableLocation);
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