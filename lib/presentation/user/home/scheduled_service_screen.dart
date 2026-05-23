import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import 'package:range_wave/controller/scheduled_service_controller.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/car_model.dart';

class ScheduledServiceScreen extends StatelessWidget {
  ScheduledServiceScreen({super.key});

  final ScheduledServiceController controller = Get.put(
    ScheduledServiceController(),
  );

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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.arrow_back),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Scheduled a Service',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),
                    AppTitle(
                      title: 'Select Your Car',
                      isShowAll: false,
                      onTap: () {},
                    ),

                    SizedBox(height: 12.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Obx(() {
                          return Row(
                            children: [
                              ...controller.carList.map((car) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 16.w),
                                  child: _selectCard(
                                    car,
                                    () => controller.selectCar(car),
                                  ),
                                );
                              }),
                              SizedBox(
                                width: 77.w,
                                height: 56.h,
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    strokeWidth: 2,
                                    color: Colors.grey,
                                    dashPattern: [5, 3],
                                    radius: Radius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add, size: 40),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    AppTitle(
                      title: 'Add Photo',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: AddPhoto(controller: controller),
                    ),

                    SizedBox(height: 24.h),

                    AppTitle(
                      title: 'Record Voice Note',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),
                    Icon(Icons.mic, size: 40, color: AppColors.blue),
                    SizedBox(height: 12.h),
                    AppTitle(
                      title: 'Describe Problem (optional)',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: TextEditingController(),
                      hintText: 'e.g, Engine is make a strange noise',
                      maxLines: 5,
                    ),
                    SizedBox(height: 12.h),
                    AppTitle(
                      title: 'Chose Date & Time',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 24.h),
                    CustomTextField(
                      controller: TextEditingController(),
                      hintText: 'select date',
                      onTap: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2030),
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                    AppTitle(title: 'Location', isShowAll: false, onTap: () {}),

                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: TextEditingController(),
                      hintText: 'select location',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      suffixIcon: Icon(Icons.edit_outlined)),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.icons.location.svg(
                          width: 24.w,
                          height: 24.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 13.w),
                        Text('Use current location',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 50.h),
                    PrimaryButton(
                      text: 'Analysis With AI',
                      backgroundColor: AppColors.primary,
                      onTap: () {
                        Get.toNamed(AppRoutes.aiDetectedIssues);
                      },
                    ),
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

class AddPhoto extends StatelessWidget {
  const AddPhoto({super.key, required this.controller});

  final ScheduledServiceController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...controller.carPhotoList.map((e) {
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () =>
                  controller.selectPhoto(controller.carPhotoList.indexOf(e)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 77.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        width: 3.w,
                        color: e.isSelected.value
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9.r),
                      child: e.imagePath.startsWith('assets/')
                          ? Image.asset(e.imagePath, fit: BoxFit.contain)
                          : Image.file(File(e.imagePath), fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                    top: 1.h,
                    right: 1.w,
                    child: GestureDetector(
                      onTap: () {
                        controller.carPhotoList.remove(e);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFDEFEE),
                        ),
                        child: Assets.icons.cancel.svg(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        GestureDetector(
          onTap: () => controller.getImage(),
          child: SizedBox(
            width: 77.w,
            height: 56.h,
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                strokeWidth: 2,
                color: Colors.grey,
                dashPattern: [5, 3],
                radius: Radius.circular(12),
              ),
              child: Center(
                child: Assets.images.addImage.image(
                  width: 22.w,
                  height: 22.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _selectCard(CarModel car, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              width: 78.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(
                  width: 3.w,
                  color: car.isSelected ? Colors.blue : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(
                car.imagePath,
                fit: BoxFit.contain,
                height: 56.w,
              ),
            ),
            if (car.isSelected)
              Positioned(
                bottom: -6.h,
                right: -8.w,
                child: Assets.icons.certified.svg(width: 20.w, height: 20.w),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          car.name,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textTernary.withValues(alpha: 0.8),
          ),
        ),
      ],
    ),
  );
}
