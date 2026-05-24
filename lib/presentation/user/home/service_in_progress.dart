import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/controller/service_in_progress_controller.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/horizontal_progress_timeline.dart';
import 'package:range_wave/presentation/user/home/widget/bill_row_section.dart';
import 'package:range_wave/presentation/user/home/widget/mechanic_card.dart';

class ServiceInProgress extends StatelessWidget {
  ServiceInProgress({super.key});

  final ServiceInProgressController controller = Get.put(
    ServiceInProgressController(),
  );

  final TextStyle normalStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: GoogleFonts.manrope().fontFamily,
  );

  final TextStyle cancelStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: GoogleFonts.manrope().fontFamily,
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
                    // ── Progress Timeline ──
                    Container(
                      width: double.infinity,
                      height: 90.h,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF54A6FF)),
                        color:Color(0xFFFEFEFE),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Obx(
                            () => HorizontalProgressTimeline(
                          steps: ['Arrived', 'Inspecting', 'Repairing', 'Completed'],
                          currentStep: controller.currentStep.value,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── Content Section ──
                    Obx(() {
                      switch (controller.currentStep.value) {
                        case 0: //  শুধু mechanic info + text
                          return Column(
                            children: [
                              mechanicCard(isAccepted: false),
                              SizedBox(height: 20.h),
                              Text('Alica Jacobe has started inspecting the car. Please allow some time while the inspection is being completed.',
                                style: normalStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );

                        case 1: //  mechanic info + bill (chat ছাড়া)
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mechanicCard(isAccepted: false),
                              SizedBox(height: 20.h),
                              billingSection(),
                            ],
                          );

                        case 2: //  mechanic info + bill (chat সহ)
                        case 3:
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mechanicCard(isAccepted: true),
                              SizedBox(height: 20.h),
                              billingSection(),
                            ],
                          );

                        default:
                          return SizedBox.shrink();
                      }
                    }),

                    SizedBox(height: 250.h),

                    // ── Buttons ──
                    Obx(() {
                      switch (controller.currentStep.value) {
                        case 0: //  শুধু Next
                          return PrimaryButton(
                            text: 'Next',
                            borderColor: AppColors.textPrimary.withValues(alpha: 0.6),
                            textStyle: cancelStyle,
                            onTap: () => controller.updateStep(
                              controller.currentStep.value + 1),
                          );

                        case 1: //  Cancel + Start
                          return Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  text: 'Cancel',
                                  borderColor: AppColors.textPrimary.withValues(alpha: 0.6),
                                  textStyle: cancelStyle,
                                  onTap: () => Get.toNamed(AppRoutes.userBottomNav),
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

                        case 2: //  শুধু Next
                          return PrimaryButton(
                            text: 'Next',
                            borderColor: AppColors.textPrimary.withValues(alpha: 0.6),
                            textStyle: cancelStyle,
                            onTap: () => controller.updateStep(
                                controller.currentStep.value + 1),
                          );

                        case 3: //  শুধু Pay Now
                          return PrimaryButton(
                            text: 'Pay Now',
                            backgroundColor: AppColors.primary,
                            onTap: () => Get.toNamed(AppRoutes.makePayment),
                          );

                        default:
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
}