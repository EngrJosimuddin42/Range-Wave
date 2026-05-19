import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/custom_text_field.dart';
import '../../../core/utils/common_widget/primary_button.dart';

class MechanicChangePasswordScreen extends StatelessWidget {
  const MechanicChangePasswordScreen({super.key});

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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              CustomTextField(
                hintText: 'Current Password',
                // error: changePassController.currentError.value,
                controller: TextEditingController(),
                isPassword: true,
              ),

              SizedBox(height: 24.h),

              CustomTextField(
                hintText: 'New Password',
                // error: changePassController.newPassError.value,
                controller: TextEditingController(),
                isPassword: true,
              ),

              SizedBox(height: 24.h),
              CustomTextField(
                hintText: 'Confirm Password',
                // error: changePassController.confirmError.value,
                controller: TextEditingController(),
                isPassword: true,
              ),
              Spacer(),
              SafeArea(
                bottom: true,
                child: PrimaryButton(
                  text: 'Update',
                  backgroundColor: AppColors.primary,
                  textStyle: TextStyle(
                    color: AppColors.surface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  // loading: changePassController.isLoading.value,
                  onTap: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
