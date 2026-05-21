import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/gen/assets.gen.dart';
import 'package:range_wave/controller/sign_in_controller.dart';

import '../../../core/utils/app_helper.dart';
import '../../../core/utils/custom_toast.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController controller = Get.put(SignInController());

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
                      'Sign in',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    _formSection(),

                    SizedBox(height: 16.h),

                    _doHaveAnyAccountSection(),

                    SizedBox(height: 40.h),

                    _bottomSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formSection() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: controller.formKey,
            child: Column(
              children: [
                CustomTextField(
                  filColor: AppColors.buttonTextColor,
                  filled: true,
                  controller: controller.emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  isEmail: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 12.h),

                CustomTextField(
                  filColor: AppColors.buttonTextColor,
                  filled: true,
                  controller: controller.passwordController,
                  hintText: 'password',
                  keyboardType: TextInputType.text,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.enterEmail);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Forget password?',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),

          SizedBox(height: 50.h),

          Obx(() {
            return PrimaryButton(
              text: 'Sign In',
              loading: controller.isLoading.value,
              backgroundColor: AppColors.primary,
              onTap: () async {
                if (controller.formKey.currentState!.validate()) {
                  final role = await controller.signin();
                  final selectedRole = await AppHelper.instance.getRole();

                  if (role == 'customer' && selectedRole == 'customer') {
                    Get.toNamed(AppRoutes.userBottomNav);
                  } else if (role == 'mechanic' && selectedRole == 'mechanic') {
                    Get.toNamed(AppRoutes.mechanicBottomNav);
                  } else if (role != null) {
                    showCustomToast(
                      text: 'Please select the correct role',
                      toastType: ToastTypesInfo(ToastTypes.error),
                    );
                  }
                }
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _bottomSection() {
    return Column(
      children: [
        Center(
          child: Text(
            'Or',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
        ),

        SizedBox(height: 40.h),

        PrimaryButton(
          text: 'Continue with google',
          leading: Assets.icons.google.svg(
            width: 24.w,
            height: 24.h,
            fit: BoxFit.contain,
          ),
          backgroundColor: AppColors.blueish,
          textStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _doHaveAnyAccountSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don’t have an account?',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),

        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.signUp);
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
