import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:range_wave/controller/forgot_pass_controller.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/core/utils/custom_toast.dart';

class EnterEmailScreen extends StatelessWidget {
  EnterEmailScreen({super.key});

  final ForgotPassController controller = Get.put(ForgotPassController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    CustomTextField(
                      filColor: AppColors.buttonTextColor,
                      filled: true,
                      controller: controller.emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      isEmail: true,
                    ),

                    SizedBox(height: 50.h),
                    Obx(() {
                      return PrimaryButton(
                        text: 'Send Code',
                        loading: controller.isLoading.value,
                        backgroundColor: AppColors.primary,
                        onTap: () async {
                          if (controller.emailController.text.isEmpty) {
                            showCustomToast(
                              text: 'Please enter your email',
                              toastType: ToastTypesInfo(ToastTypes.error),
                            );
                            return;
                          }
                          final okay = await controller.verifyEmail();
                          if (okay) {
                            Get.toNamed(AppRoutes.verifyOtp);
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
      ),
    );
  }
}
