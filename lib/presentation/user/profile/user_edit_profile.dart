import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import 'package:range_wave/core/utils/common_widget/image_uploader.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';

import '../../../core/utils/color/app_colors.dart';

class UserEditProfile extends StatelessWidget {
  const UserEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: ImageUploaderVOne(height: 110.h)),

              SizedBox(height: 20.h),

              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Name - Randy Orthon',
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Email - daniel_austin@yourdomain.com',
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: IntlPhoneField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.4),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.textPrimary.withValues(alpha: 0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.textPrimary.withValues(alpha: 0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.textPrimary.withValues(alpha: 0.2),
                            width: 1.5.w,
                          ),
                        ),
                      ),
                      initialCountryCode: 'CA',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Address Title...',
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 24.w,
                ),
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: '207. Sk. No:5',
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: '9',
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'New York',
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'New Mexico',
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 24.w,
                ),
              ),
              SizedBox(height: 8.h),

              CustomTextField(
                controller: TextEditingController(),
                hintText: '33143',
              ),

              SizedBox(height: 50.h),
              PrimaryButton(
                text: 'Save Changes',
                backgroundColor: AppColors.primary,
                onTap: () {
                  Get.back();
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
