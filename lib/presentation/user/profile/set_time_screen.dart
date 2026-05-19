import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class SetTimeScreen extends StatelessWidget {
  SetTimeScreen({super.key});

  final TextEditingController startTimeController = TextEditingController(
    text: 'select',
  );
  final TextEditingController endTimeController = TextEditingController(
    text: 'select',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Set time & date'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              AppTitle(title: 'Availability', isShowAll: false, onTap: () {}),
              SizedBox(height: 16.h),
              WeekendCard(isCheck: true, day: 'Monday'),
              SizedBox(height: 16.h),
              WeekendCard(isCheck: true, day: 'Tuesday'),
              SizedBox(height: 16.h),
              WeekendCard(isCheck: true, day: 'Wednesday'),
              SizedBox(height: 16.h),
              WeekendCard(isCheck: true, day: 'Thursday'),
              SizedBox(height: 16.h),
              WeekendCard(isCheck: false, day: 'Friday'),
              SizedBox(height: 16.h),

              WeekendCard(isCheck: true, day: 'Saturday'),
              SizedBox(height: 16.h),
              WeekendCard(isCheck: true, day: 'Sunday'),

              SizedBox(height: 24.h),
              AppTitle(title: 'Timings', isShowAll: false, onTap: () {}),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start Time'),
                        SizedBox(height: 12.h),
                        CustomTextField(
                          prefixIcon: Assets.icons.clock.svg(
                            color: AppColors.primary,
                          ),
                          controller: startTimeController,
                          onTap: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              final now = DateTime.now();
                              final dt = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              final format = DateFormat('HH:mm');
                              startTimeController.text = format.format(
                                dt,
                              ); // e.g., 20:20
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('End Time'),
                        SizedBox(height: 12.h),
                        CustomTextField(
                          prefixIcon: Assets.icons.clock.svg(
                            color: AppColors.primary,
                          ),
                          controller: endTimeController,
                          onTap: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              final now = DateTime.now();
                              final dt = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              final format = DateFormat('HH:mm');
                              endTimeController.text = format.format(
                                dt,
                              ); // e.g., 20:20
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 48.h),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: 'Cancel',
                      borderColor: AppColors.textPrimary.withValues(alpha: 0.6),
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Pay Now',
                      backgroundColor: AppColors.primary,
                      onTap: () {
                        Get.toNamed(AppRoutes.mechanicBottomNav);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}

class WeekendCard extends StatelessWidget {
  final bool isCheck;
  final String day;

  const WeekendCard({super.key, required this.isCheck, required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.white,
      ),
      child: Row(
        children: [
          Checkbox(
            value: isCheck,
            onChanged: (value) {},
            shape: CircleBorder(),
            activeColor: AppColors.primary,
          ),
          Text(
            day,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
