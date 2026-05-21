import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:range_wave/controller/profile_controller.dart';
import 'package:range_wave/core/utils/custom_toast.dart';

import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/custom_text_field.dart';
import '../../../core/utils/common_widget/primary_button.dart';

class MechanicChangePasswordScreen extends StatelessWidget {
  const MechanicChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ProfileController controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Change Password'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.surface,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),

              CustomTextField(
                hintText: 'Current Password',
                controller: controller.oldPasswordController,
                isPassword: true,
              ),

              SizedBox(height: 24.h),

              CustomTextField(
                hintText: 'New Password',
                controller: controller.newPasswordController,
                isPassword: true,
              ),

              SizedBox(height: 24.h),

              CustomTextField(
                hintText: 'Confirm Password',
                controller: controller.confirmPasswordController,
                isPassword: true,
              ),

              const Spacer(),

              Obx(() => PrimaryButton(
                text: 'Update',
                backgroundColor: AppColors.primary,
                textStyle: TextStyle(
                  color: AppColors.surface,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                loading: controller.isLoading.value,
                onTap: () async {

                  if (controller.oldPasswordController.text.trim().isEmpty ||
                      controller.newPasswordController.text.trim().isEmpty ||
                      controller.confirmPasswordController.text.trim().isEmpty) {
                    showCustomToast(
                      text: 'All fields are required',
                      toastType: ToastTypesInfo(ToastTypes.error),
                    );
                    return;
                  }

                  if (controller.newPasswordController.text != controller.confirmPasswordController.text) {
                    showCustomToast(
                      text: 'New password and confirm password do not match',
                      toastType: ToastTypesInfo(ToastTypes.error),
                    );
                    return;
                  }

                  if (controller.newPasswordController.text.trim().length < 6) {
                    showCustomToast(
                      text: 'Password must be at least 6 characters',
                      toastType: ToastTypesInfo(ToastTypes.error),
                    );
                    return;
                  }

                  bool isSuccess = await controller.changePassword();

                  if (isSuccess) {
                    Get.back();
                  }
                },
              )),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}