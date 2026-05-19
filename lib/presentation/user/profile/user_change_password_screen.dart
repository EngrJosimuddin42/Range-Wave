import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/profile_controller.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/custom_text_field.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../core/utils/custom_toast.dart';

class UserChangePasswordScreen extends StatelessWidget {
  UserChangePasswordScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Change Password'),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.surface,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  hintText: 'Current Password',
                  controller: controller.oldPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter current password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  hintText: 'New Password',
                  controller: controller.newPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  hintText: 'Confirm Password',
                  controller: controller.confirmPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != controller.newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                Obx(
                  () => PrimaryButton(
                    text: 'Update',
                    backgroundColor: AppColors.primary,
                    loading: controller.isLoading.value,
                    textStyle: TextStyle(
                      color: AppColors.surface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await controller.changePassword();
                        if (success) {
                          showCustomToast(
                            text: 'Password changed successfully',
                            toastType: ToastTypesInfo(ToastTypes.success),
                          );
                          Get.back();
                        }
                      }
                    },
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
