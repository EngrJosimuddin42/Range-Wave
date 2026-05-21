import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:range_wave/controller/forgot_pass_controller.dart';
import 'package:range_wave/controller/signup_controller.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/gen/assets.gen.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ForgotPassController controller = Get.put(ForgotPassController());
  final SignupController signupController = Get.find<SignupController>();

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
                    'Set new password',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  CustomTextField(
                    filColor: AppColors.buttonTextColor,
                    filled: true,
                    controller: controller.newPasswordController,
                    hintText: 'Enter new password...',
                    keyboardType: TextInputType.emailAddress,
                    isPassword: true,
                  ),

                  SizedBox(height: 12.h),
                  CustomTextField(
                    filColor: AppColors.buttonTextColor,
                    filled: true,
                    controller: controller.confirmPasswordController,
                    hintText: 'Re-enter password...',
                    keyboardType: TextInputType.emailAddress,
                    isEmail: true,
                    isPassword: true,
                  ),

                  SizedBox(height: 50.h),

                  Obx(() {
                    return PrimaryButton(
                      text: 'Save & Continue',
                      loading: controller.isLoading.value,
                      backgroundColor: AppColors.primary,
                      onTap: () async {
                        if (controller.confirmPasswordController.text.trim() !=
                            controller.newPasswordController.text.trim()) {
                          showCustomToast(text: "Passwords do not match");
                          return;
                        }
                        final okay = await controller.resetPassword();

                        if (okay) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 20.h,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Assets.images.congrats.image(),
                                      SizedBox(height: 32.h),
                                      Text(
                                        'Congratulations',
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'Your password has been reset successfully.',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 32.h),
                                      PrimaryButton(
                                        text: 'Next',
                                        backgroundColor: AppColors.primary,
                                        onTap: () {
                                          if (signupController
                                                  .selectedRole
                                                  .value ==
                                              'customer') {
                                            Get.toNamed(
                                              AppRoutes.userBottomNav,
                                            );
                                          } else {
                                            Get.toNamed(
                                              AppRoutes.mechanicBottomNav,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
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
