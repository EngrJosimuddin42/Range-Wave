import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/controller/live_mechanic_controller.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/horizontal_progress_timeline.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/gen/assets.gen.dart';

class LiveMechanicTrackScreen extends StatelessWidget {
  LiveMechanicTrackScreen({super.key});

  final LiveMechanicController controller =
  Get.put(LiveMechanicController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Obx(() => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Top bar ──────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 16.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      '${controller.booking.carBrand} ${controller.booking.carModel}',
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

                    // ── Progress Timeline ──────────────────
                    Container(
                      width: double.infinity,
                      height: 90.h,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF54A6FF)),
                        color: const Color(0xFFFEFEFE),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: HorizontalProgressTimeline(
                        steps: ['Arrived', 'Inspecting', 'Repairing', 'Completed'],
                        currentStep: controller.currentStep.value,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── Customer card ──────────────────────
                    _CustomerCard(controller: controller),

                    SizedBox(height: 20.h),

                    // ── Step content ───────────────────────
                    _StepContent(controller: controller),

                    SizedBox(height: 40.h),

                    // ── Action buttons ─────────────────────
                    _ActionButtons(controller: controller),

                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Customer card
// ════════════════════════════════════════════════════════════
class _CustomerCard extends StatelessWidget {
  final LiveMechanicController controller;
  const _CustomerCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.r,
            offset: const Offset(0, 2),
            color: AppColors.textPrimary.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.surface,
                child: Icon(Icons.person, size: 28.w,
                    color: AppColors.textTernary),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.booking.customerName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                    Text(
                      controller.booking.customerEmail,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textTernary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ── AI Summary ─────────────────────────────────
          Text(
            'Details',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Summary',
                style: TextStyle(fontSize: 14.sp, color: AppColors.textTernary),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFD3F4DE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  controller.booking.issueSummary.isEmpty
                      ? 'No Issue'
                      : controller.booking.issueSummary,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Severity Level',
                  style: TextStyle(fontSize: 14.sp,
                      color: AppColors.textTernary)),
              Row(
                children: [
                  Container(
                    width: 8.w, height: 8.w,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    controller.booking.severityLevel.isEmpty
                        ? 'N/A'
                        : controller.booking.severityLevel,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (controller.booking.estimatedAmount != null) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Estimate Amount',
                    style: TextStyle(fontSize: 14.sp,
                        color: AppColors.textTernary)),
                Row(
                  children: [
                    Container(
                      width: 8.w, height: 8.w,
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '\$${controller.booking.estimatedAmount}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          SizedBox(height: 8.h),
          Text(
            controller.booking.issueDetail.isEmpty
                ? ''
                : controller.booking.issueDetail,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textTernary,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Step content
// ════════════════════════════════════════════════════════════
class _StepContent extends StatelessWidget {
  final LiveMechanicController controller;
  const _StepContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    switch (controller.currentStep.value) {
      case 0: // Arrived — no bill
        return const SizedBox.shrink();

      case 1: // Inspecting — add bill
      case 2: // Repairing — show bill
        return _BillSection(controller: controller);

      case 3: // Completed
        return _CompletedSection();

      default:
        return const SizedBox.shrink();
    }
  }
}

// ════════════════════════════════════════════════════════════
//  Bill section
// ════════════════════════════════════════════════════════════
class _BillSection extends StatelessWidget {
  final LiveMechanicController controller;
  const _BillSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.r,
            offset: const Offset(0, 2),
            color: AppColors.textPrimary.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
          SizedBox(height: 12.h),

          // ── Dynamic bill rows ──────────────────────────
          Obx(() => Column(
            children: controller.billItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item  = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: item.nameController,
                        decoration: InputDecoration(
                          hintText: 'Service name',
                          hintStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textTernary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 8.h),
                        ),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: item.priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          hintText: '\$0',
                          hintStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textTernary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 8.h),
                        ),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    GestureDetector(
                      onTap: () => controller.removeBillItem(index),
                      child: Icon(Icons.remove_circle_outline,
                          color: Colors.red, size: 22.w),
                    ),
                  ],
                ),
              );
            }).toList(),
          )),

          // ── Add More button ────────────────────────────
          GestureDetector(
            onTap: () => controller.addBillItem(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline,
                    color: AppColors.primary, size: 20.w),
                SizedBox(width: 6.w),
                Text(
                  '+ Add More',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Completed section
// ════════════════════════════════════════════════════════════
class _CompletedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.paymentSuccess.image(height: 180.h),
        SizedBox(height: 20.h),
        Text(
          'You have completed the repairs on this car.',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Action buttons by step
// ════════════════════════════════════════════════════════════
class _ActionButtons extends StatelessWidget {
  final LiveMechanicController controller;
  const _ActionButtons({required this.controller});

  @override
  Widget build(BuildContext context) {
    switch (controller.currentStep.value) {
      case 0: // Arrived → Start Now
        return Obx(() => PrimaryButton(
          loading: controller.isLoading.value,
          text: 'Start Now',
          backgroundColor: AppColors.primary,
          onTap: () => controller.nextStep(),
        ));

      case 1: // Inspecting → Inspection (submit bill)
        return Obx(() => PrimaryButton(
          loading: controller.isLoading.value,
          text: 'Inspection',
          backgroundColor: AppColors.primary,
          onTap: () => controller.submitBill(),
        ));

      case 2: // Repairing → Repairing button
        return Obx(() => PrimaryButton(
          loading: controller.isLoading.value,
          text: 'Repairing',
          backgroundColor: AppColors.primary,
          onTap: () => controller.nextStep(),
        ));

      case 3: // Completed → Get Paid
        return Obx(() => PrimaryButton(
          loading: controller.isLoading.value,
          text: 'Get Paid',
          backgroundColor: AppColors.primary,
          onTap: () => controller.getPaid(),
        ));

      default:
        return const SizedBox.shrink();
    }
  }
}