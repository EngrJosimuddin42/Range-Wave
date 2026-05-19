import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/color/app_colors.dart';

class UserPrivacyScreen extends StatefulWidget {
  const UserPrivacyScreen({super.key});

  @override
  State<UserPrivacyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<UserPrivacyScreen> {
  Widget _listText(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5.w,
            height: 5.w,
            margin: EdgeInsets.only(top: 7.h),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.hintText,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.hintText,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _normalText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.hintText,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.border.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16.w,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                    Text(
                      'Privacy & Policy',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(flex: 3),
                  ],
                ),
              ),
              SizedBox(height: 36.h),
              Text(
                '1. Types of Data We Collect',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 18.h),
              _listText(
                'Emotional check-ins: Feelings or reflections you choose to share during resets.',
              ),
              _listText(
                'App usage: Which features you use, when, and how often.',
              ),
              _listText(
                'Account info: If you sign up, we store your email and any profile info you enter.',
              ),
              _listText(
                'Device data: Basic info like your phone model, OS version, and country (used only to improve the app experience).',
              ),
              _normalText(
                'We do not collect any data without your permission.',
              ),
              SizedBox(height: 24.h),
              Text(
                '2. Use of Your Personal Data',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              _listText('Personalize your reset experience.'),
              _listText('Track you progress over time (if you chose).'),
              _listText('Improve the app and offer better tools.'),
              _listText('Respond to support request or feedback.'),
              _normalText('Your data is never sold or used for ads. Ever.'),
              SizedBox(height: 24.h),
              Text(
                '3. Disclosure of Your Personal Data',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              _listText(
                'It\'s needed to run the app (like with secure cloud service)',
              ),
              _listText('Required by law or safety concerns.'),
              _listText('You give us direct permission.'),
              _normalText(
                'We keep all data encrypted and secure. You can delete your data or account anytime in settings.',
              ),
              SizedBox(height: 118.h),
            ],
          ),
        ),
      ),
    );
  }
}
