import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import 'package:range_wave/core/utils/common_widget/image_uploader.dart';
import 'package:range_wave/gen/assets.gen.dart';

import '../../../core/utils/color/app_colors.dart';

class MechanicEditProfile extends StatelessWidget {
  const MechanicEditProfile({super.key});

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
                hintText: 'Full Name',
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Enter shop name',
              ),

              SizedBox(height: 8.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Enter initial service charge',
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Yer of experience',
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Service area',
              ),
              SizedBox(height: 8.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Specialist',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),

                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        SpecialistCard(speciality: 'Engine repair'),
                        SizedBox(width: 10.w),
                        SpecialistCard(speciality: 'Brakes'),
                      ],
                    ),

                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: TextEditingController(),
                      hintText: 'Add specialty....',
                    ),

                    SizedBox(height: 12.h),

                    Text(
                      'Add Certificate',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.file_present),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SpecialistCard extends StatelessWidget {
  final String speciality;

  const SpecialistCard({super.key, required this.speciality});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.blueish,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            speciality,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.blue,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: () {},
            child: Assets.icons.cancel.svg(
              width: 14.w,
              height: 14.h,
              color: AppColors.blue,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
