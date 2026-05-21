import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/common_widget/icon_container.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/controller/service_in_progress_controller.dart';
import 'package:range_wave/presentation/user/home/widget/bill_row.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/horizontal_progress_timeline.dart';
import 'package:range_wave/gen/assets.gen.dart';

class ServiceInProgress extends StatelessWidget {
  ServiceInProgress({super.key});

  final ServiceInProgressController controller = Get.put(
    ServiceInProgressController(),
  );

  final TextStyle headingStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: GoogleFonts.manrope().fontFamily,
  );

  final TextStyle normalStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: GoogleFonts.manrope().fontFamily,
  );

  final List<Map<String, dynamic>> bills = [
    {'title': 'Mechanic Arrived', 'time': '10.30 AM', 'price': '\$550'},
    {'title': 'Oil Changes', 'time': '10.55 AM', 'price': '\$123'},
    {'title': 'Break Pad', 'time': '11.00 AM', 'price': '\$550'},
    {'title': 'Extra Service Charge', 'time': '11.30 AM', 'price': '\$550'},
    {
      'title': 'Total',
      'time': '10.30 AM',
      'price': '\$550',
      'isShowTime': false,
    },
  ];

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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Service In Progress',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    // Progress Timeline
                    Container(
                      width: double.infinity,
                      height: 90.h,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Obx(
                        () => HorizontalProgressTimeline(
                          steps: [
                            'Arrived',
                            'Inspecting',
                            'Repairing',
                            'Completed',
                          ],
                          currentStep: controller.currentStep.value,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Obx(() {
                      switch (controller.currentStep.value) {
                        // case 0:
                        //   return _mechanicInfo(controller);

                        case 0: // Inspecting
                          return Column(
                            children: [
                              _mechanicInfo(controller),
                              SizedBox(height: 20.h),
                              Text(
                                'Alica Jacobe has started inspecting the car. Please allow some time while the inspection is being completed.',
                                style: normalStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        case 1:
                        case 2: // Billing
                        case 3: // Completed + show bill
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _mechanicInfo(controller),
                              SizedBox(height: 20.h),
                              AppTitle(
                                title: 'Bill',
                                isShowAll: false,
                                onTap: () {},
                              ),
                              SizedBox(height: 20.h),
                              ...bills.map(
                                (bill) => Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: BillRow(
                                    title: bill['title'],
                                    time: bill['time'],
                                    price: bill['price'],
                                    isShowTime: bill['isShowTime'] ?? true,
                                  ),
                                ),
                              ),
                            ],
                          );

                        default:
                          return SizedBox.shrink();
                      }
                    }),

                    SizedBox(height: 70.h),

                    // Buttons
                    Obx(() {
                      if (controller.currentStep.value < 2) {
                        return PrimaryButton(
                          text: 'Next',
                          backgroundColor: AppColors.primary,
                          onTap: () => controller.updateStep(
                            controller.currentStep.value + 1,
                          ),
                        );
                      } else if (controller.currentStep.value == 2) {
                        return Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: 'Cancel',
                                borderColor: AppColors.textPrimary.withOpacity(
                                  0.6,
                                ),
                                textStyle: headingStyle,
                                onTap: () {
                                  Get.toNamed(AppRoutes.userBottomNav);
                                },
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: PrimaryButton(
                                text: 'Next',
                                backgroundColor: AppColors.primary,
                                onTap: () => controller.updateStep(
                                  controller.currentStep.value + 1,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (controller.currentStep.value == 3) {
                        return PrimaryButton(
                          text: 'Pay now',
                          backgroundColor: AppColors.primary,
                          onTap: () {
                            Get.toNamed(AppRoutes.makePayment);
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),

                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for mechanic info section
  Widget _mechanicInfo(ServiceInProgressController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: Assets.images.user.provider(),
            radius: 28.r,
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alexanders Lol', style: headingStyle),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Assets.icons.ratingFilled.svg(),
                  SizedBox(width: 4.w),
                  Text('4.5'),
                ],
              ),
            ],
          ),
          Spacer(),
          if (controller.currentStep.value > 2)
            IconContainer(path: Assets.icons.chat.path, onTap: () {}),
        ],
      ),
    );
  }
}
