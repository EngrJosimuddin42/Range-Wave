import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:range_wave/controller/forgot_pass_controller.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/core/utils/custom_toast.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final ForgotPassController controller = Get.find<ForgotPassController>();

  @override
  void initState() {
    super.initState();
    controller.startTimer();
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

            SizedBox(height: 100.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check your inbox',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  OtpTextField(
                    numberOfFields: 4,
                    cursorColor: AppColors.textPrimary,
                    fillColor: AppColors.buttonTextColor,
                    filled: true,
                    focusedBorderColor: AppColors.primary,
                    enabledBorderColor: AppColors.buttonTextColor,
                    showFieldAsBox: true,
                    borderRadius: BorderRadius.circular(12.r),
                    fieldWidth: 61.w,
                    borderWidth: 1.5,
                    fieldHeight: 61.w,
                    textStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onCodeChanged: (String code) {},
                    onSubmit: (String verificationCode) {
                      controller.otp = verificationCode;
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Timer / Resend button
                  Obx(() {
                    if (controller.canResend.value) {
                      return Center(
                        child: TextButton(
                          onPressed: () async {
                            await controller.resendCode();
                          },
                          child: Text(
                            'Resend',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Resend code in',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary.withValues(alpha: 0.5),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          controller.formattedTime,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 50.h),

                  Obx(() {
                    return PrimaryButton(
                      text: 'Verify',
                      loading: controller.isLoading.value,
                      backgroundColor: AppColors.primary,
                      onTap: () async {
                        if (controller.otp.isEmpty) {
                          showCustomToast(text: 'Please enter OTP');
                          return;
                        }
                        final okay = await controller.verifyOtp();
                        if (okay) {
                          Get.toNamed(AppRoutes.resetPass);
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
