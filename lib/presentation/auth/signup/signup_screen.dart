import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/gen/assets.gen.dart';
import '../../../controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final SignupController controller = () {
    try {
      final c = Get.find<SignupController>();
      print('✅ SignupController found: role = ${c.selectedRole.value}');
      return c;
    } catch (e) {
      print('❌ SignupController NOT found: $e');
      return Get.put(SignupController(), permanent: true);
    }
  }();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      'Create a new account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 32.h),
                    _formSection(controller),

                    SizedBox(height: 16.h),
                    _doHaveAnyAccountSection(),
                    SizedBox(height: 28.h),

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
}

Widget _formSection(SignupController controller) {
  return Column(
    children: [
      Form(
        key: controller.formKey,
        child: Column(
          children: [
            CustomTextField(
              filColor: AppColors.buttonTextColor,
              filled: true,
              controller: controller.nameController,
              hintText: 'Enter your name',
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            CustomTextField(
              filColor: AppColors.buttonTextColor,
              filled: true,
              controller: controller.emailController,
              hintText: 'Enter email',
              keyboardType: TextInputType.emailAddress,
              isEmail: true,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!GetUtils.isEmail(value.trim())) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            CustomTextField(
              filColor: AppColors.buttonTextColor,
              filled: true,
              controller: controller.passwordController,
              hintText: 'Enter password',
              keyboardType: TextInputType.text,
              isPassword: true,
              validator: (value) {
                if (value!.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            CustomTextField(
              filColor: AppColors.buttonTextColor,
              filled: true,
              controller: controller.confirmPasswordController,
              hintText: 'Re-enter password',
              keyboardType: TextInputType.text,
              isPassword: true,
              validator: (value) {
                if (controller.passwordController.text != value) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      Row(
        children: [
          Obx(() {
            return Checkbox(
              activeColor: Colors.white,
              checkColor: AppColors.blue,
              value: controller.isAgreed.value,
              onChanged: (value) {
                controller.isAgreed.value = value ?? false;
              },
            );
          }),
          Text(
            'I agree with',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary.withValues(alpha: 0.5),
            ),
          ),
          Text(
            ' privacy policy.',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.blue,
            ),
          ),
        ],
      ),

      SizedBox(height: 50),
      Obx(() {
        return PrimaryButton(
          text: 'Sign Up',
          loading: controller.isLoading.value,
          backgroundColor: AppColors.primary,
          onTap: () async {
            if (controller.isAgreed.value == false) {
              showCustomToast(
                text: 'Please agree to the terms and conditions',
                toastType: ToastTypesInfo(ToastTypes.error),
              );
              return;
            }
            if (controller.formKey.currentState!.validate()) {
              final okay = await controller.signup();
              if (okay) {
                Get.offAllNamed(AppRoutes.verifyEmail);
              }
            }
          },
        );
      }),
    ],
  );
}

Widget _doHaveAnyAccountSection() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Already have an account?',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
      ),

      TextButton(
        onPressed: () {
          Get.toNamed(AppRoutes.signIn);
        },
        child: Text(
          'Sign In',
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
