import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/controller/car_controller.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import '../../../../core/utils/common_widget/added_car_card.dart';
import '../../../../core/utils/common_widget/custom_text_field.dart';
import '../../../../gen/assets.gen.dart';

class CarListScreen extends StatelessWidget {
  CarListScreen({super.key});

  final CarController controller = Get.find<CarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text( 'Car List',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => controller.isLoading2.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : controller.carList.isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTitle(
                                  title: 'My Cars',
                                  isShowAll: false,
                                  onTap: () {}),
                                SizedBox(height: 20.h),
                                SizedBox(
                                  height: 160.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.carList.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: 16.w),
                                    itemBuilder: (context, index) {
                                      final car = controller.carList[index];
                                      return AddedCarCard(
                                        carName: car.brand,
                                        carModel: car.model,
                                        image: car.imageUrl,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 24.h),
                              ],
                            ),
                    ),
                    AppTitle(
                      title: 'Add Another Car',
                      isShowAll: false,
                      onTap: () {},
                    ),

                    SizedBox(height: 20.h),
                    _dottedContainer(controller: controller),
                    SizedBox(height: 16.h),

                    CustomTextField(
                      filColor: AppColors.buttonTextColor,
                      filled: true,
                      controller: controller.brandNameController,
                      hintText: 'Enter car brand name',
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      filColor: AppColors.buttonTextColor,
                      filled: true,
                      controller: controller.modelNameController,
                      hintText: 'Enter car model',
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      filColor: AppColors.buttonTextColor,
                      filled: true,
                      controller: controller.codeController,
                      hintText: 'Enter code',
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      filColor: AppColors.buttonTextColor,
                      filled: true,
                      readOnly: true,
                      controller: controller.yearController,
                      hintText: 'Select Year',
                      keyboardType: TextInputType.text,
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(DateTime.now().year + 5),
                          );
                          if (picked != null) {
                            controller.yearController.text = picked.year
                                .toString(); // only year
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 24.w,
                          color: AppColors.textPrimary.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      filColor: AppColors.buttonTextColor,
                      filled: true,
                      controller: controller.licensePlateController,
                      hintText: 'Enter license plate number',
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      filColor: AppColors.buttonTextColor,
                      filled: true,
                      controller: controller.tagNumberController,
                      hintText: 'Enter tag number',
                      keyboardType: TextInputType.text,
                    ),

                    SizedBox(height: 32.h),

                    Obx(() {
                      return PrimaryButton(
                        loading: controller.isLoading.value,
                        text: 'Save & Continue',
                        backgroundColor: AppColors.primary,
                        textStyle: TextStyle(
                          color: AppColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontStyle: GoogleFonts.manrope().fontStyle,
                        ),
                        onTap: () async {
                          final okay = await controller.customerAddCar();
                          if (okay) {
                            showCustomToast(
                              text: 'Car added successfully',
                              toastType: ToastTypesInfo(ToastTypes.success),
                            );
                            Get.back();
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _dottedContainer({required CarController controller}) {
  return Obx(() {
    if (controller.selectedImages.isEmpty) {
      return DottedBorder(
        options: RectDottedBorderOptions(
          color: AppColors.hintText.withValues(alpha: 0.6),
          strokeWidth: 2,
          dashPattern: [6, 3],
        ),
        child: GestureDetector(
          onTap: controller.getImages,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.isImageLoading.value)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  )
                else
                  Assets.images.addImage.image(),
                SizedBox(height: 10.h),
                Text(
                  controller.isImageLoading.value
                      ? "Uploading photo..."
                      : "Upload Car Photo",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontStyle: GoogleFonts.manrope().fontStyle,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Tap to add a photo (Optimal)",
                  style: TextStyle(
                    color: AppColors.textTernary.withValues(alpha: 0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 110.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.selectedImages.length + 1,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              if (index == controller.selectedImages.length) {
                // Add more button
                return GestureDetector(
                  onTap: controller.getImages,
                  child: DottedBorder(
                    options: RectDottedBorderOptions(
                      color: AppColors.hintText.withValues(alpha: 0.6),
                      strokeWidth: 2,
                      dashPattern: [4, 2],
                    ),
                    child: Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColors.primary,
                            size: 24.w,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Add More",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final image = controller.selectedImages[index];
              return Stack(
                children: [
                  Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: FileImage(File(image.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(index),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14.w,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        if (controller.isImageLoading.value)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                minHeight: 4.h,
              ),
            ),
          ),
      ],
    );
  });
}
