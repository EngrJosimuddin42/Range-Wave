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
import 'package:range_wave/controller/car_controller.dart';
import 'package:range_wave/presentation/user/home/widget/inline_date_picker_widget.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../map/select_location_map_screen.dart';
import 'widget/voice_recorder_widget.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/car_list_model.dart';

class ScheduledServiceScreen extends StatelessWidget {
  ScheduledServiceScreen({super.key});

  final ScheduledServiceController controller = Get.put(
    ScheduledServiceController(),
  );
  final CarController carController = Get.find<CarController>();

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

                    // ── Top bar ──────────────────────────────────────────
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back),
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

                    // ── Select Your Car ──────────────────────────────────
                    AppTitle(
                      title: 'Select Your Car',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),

                    Obx(() {
                      if (carController.isLoading2.value) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }

                      if (carController.carList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Text(
                              'No cars added yet.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textTernary,
                              ),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: Row(
                            children: [
                              ...carController.carList.map((car) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 16.w),
                                  child: Obx(
                                        () => _SelectCarCard(
                                      car: car,
                                      isSelected:
                                      controller.selectedCar.value == car,
                                      onTap: () => controller.selectCar(car),
                                    ),
                                  ),
                                );
                              }),

                              // ── Add new car button ──
                              GestureDetector(
                                  onTap: () async {
                                    await Get.toNamed(AppRoutes.carList);
                                    carController.getCars(force: true);
                                  },
                                child: SizedBox(
                                  width: 77.w,
                                  height: 80.h,
                                  child: DottedBorder(
                                    options: RoundedRectDottedBorderOptions(
                                      strokeWidth: 2,
                                      color: Colors.grey,
                                      dashPattern: const [5, 3],
                                      radius: const Radius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.add, size: 40),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 20.h),

                    // ── Add Photo ────────────────────────────────────────
                    AppTitle(
                      title: 'Add Photo',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _AddPhoto(controller: controller),
                    ),

                    SizedBox(height: 24.h),

                    // ── Record Voice Note ────────────────────────────────
                    AppTitle(
                      title: 'Record Voice Note',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),

                    VoiceRecorderWidget(
                      onRecorded: (path) {
                        controller.voiceNotePath = path;
                      },
                    ),
                    SizedBox(height: 12.h),

                    // ── Describe Problem ─────────────────────────────────
                    AppTitle(
                      title: 'Describe Problem (optional)',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: controller.problemController,
                      hintText: 'e.g, Engine is making a strange noise',
                      maxLines: 5,
                    ),

                    SizedBox(height: 12.h),

                    // ── Date & Time ──────────────────────────────────────
                    AppTitle(
                      title: 'Choose Date & Time',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),

                    InlineDatePickerWidget(controller: controller),

                    SizedBox(height: 24.h),

                    // ── Location ─────────────────────────────────────────
                    AppTitle(
                      title: 'Location',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: controller.locationController,
                      hintText: 'Select location',
                      readOnly: true,
                      onTap: () async {
                        final resultMap = await Get.to(() => const SelectLocationMapScreen());
                        if (resultMap != null && resultMap is Map<String, dynamic>) {
                          controller.updateManualLocation(resultMap);
                        }
                      },
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w), 
                        child: Assets.icons.location1.svg(
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.contain,
                        ),
                      ),

                      suffixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Assets.icons.edit1.svg( width: 18.w, height: 18.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: () => controller.useCurrentLocation(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.icons.location.svg(
                              width: 24.w,
                              height: 24.w,
                              fit: BoxFit.contain),
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
                    ),

                    SizedBox(height: 50.h),

                    // ── Submit Button ────────────────────────────────────
                    Obx(() => PrimaryButton(
                      loading: controller.isSubmitting.value,
                      text: 'Analysis With AI',
                      backgroundColor: AppColors.primary,
                      onTap: () async {
                        final result = await controller.submitIssue();
                        if (result != null) {
                          Get.toNamed(
                            AppRoutes.aiDetectedIssues,
                            arguments: result,
                          );
                        }
                      },
                    )),

                    SizedBox(height: 20.h),
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

class _SelectCarCard extends StatelessWidget {
  const _SelectCarCard({
    required this.car,
    required this.isSelected,
    required this.onTap,
  });

  final CarListModel car;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 90.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(
                    width: 2.5.w,
                    color: isSelected ? Colors.blue : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    car.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.directions_car,
                        size: 36,
                        color: AppColors.textTernary,
                      ),
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (isSelected)
                Positioned(
                  bottom: -6.h,
                  right: -6.w,
                  child: Assets.icons.certified.svg(
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
            ],
          ),

          SizedBox(height: 8.h),

          SizedBox(
            width: 90.w,
            child: Text(
              car.brand,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? AppColors.blue
                    : AppColors.textTernary.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _AddPhoto extends StatelessWidget {
  const _AddPhoto({required this.controller});
  final ScheduledServiceController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          ...controller.carPhotoList.map((photo) {
            final index = controller.carPhotoList.indexOf(photo);
            return Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () => controller.selectPhoto(index),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(
                          () => Container(
                        width: 77.w,
                        height: 56.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            width: 3.w,
                            color: photo.isSelected.value
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9.r),
                          child: Image.file(
                            File(photo.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1.h,
                      right: 1.w,
                      child: GestureDetector(
                        onTap: () => controller.carPhotoList.remove(photo),
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: const BoxDecoration(
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

          // Add photo button
          GestureDetector(
            onTap: () => controller.getImage(),
            child: SizedBox(
              width: 77.w,
              height: 56.h,
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  strokeWidth: 2,
                  color: Colors.grey,
                  dashPattern: const [5, 3],
                  radius: const Radius.circular(12),
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
    });
  }
}