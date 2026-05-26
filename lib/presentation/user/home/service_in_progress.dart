// lib/presentation/user/home/mechanic_service_in_progress.dart

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
import 'package:range_wave/model/booking_detail_model.dart';

class ServiceInProgress extends StatelessWidget {
  ServiceInProgress({super.key});

  final ServiceInProgressController controller =
  Get.put(ServiceInProgressController());

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
        child: Obx(() {

          // ── Loading ─────────────────────────────────────
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final booking = controller.booking.value;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTopLogo(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 16.h),
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

                      // ── Progress Timeline ──────────────
                      Container(
                        width: double.infinity,
                        height: 90.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF54A6FF)),
                          color: const Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Obx(() => HorizontalProgressTimeline(
                          steps: ['Arrived', 'Inspecting', 'Repairing', 'Completed'],
                          currentStep: controller.currentStep.value,
                        )),
                      ),

                      SizedBox(height: 20.h),

                      // ── Mechanic Card ──────────────────
                      if (booking != null)
                        _MechanicCard(booking: booking),

                      SizedBox(height: 20.h),

                      // ── Content by step ────────────────
                      if (booking != null)
                        Obx(() => _StepContent(
                          booking    : booking,
                          currentStep: controller.currentStep.value,
                        )),

                      SizedBox(height: 40.h),

                      // ── Buttons ────────────────────────
                      Obx(() => _ActionButtons(
                        currentStep: controller.currentStep.value,
                        onNext  : () => controller.updateStep(
                            controller.currentStep.value + 1),
                        onCancel: () => Get.toNamed(AppRoutes.userBottomNav),
                        onPay   : () => Get.toNamed(
                          AppRoutes.makePayment,
                          arguments: booking,
                        ),
                        cancelStyle: cancelStyle,
                      )),

                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Mechanic Card — dynamic
// ════════════════════════════════════════════════════════════
class _MechanicCard extends StatelessWidget {
  final BookingDetailModel booking;
  const _MechanicCard({required this.booking});

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
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: AppColors.surface,
            backgroundImage: booking.user.avatarUrl.isNotEmpty
                ? NetworkImage(booking.user.avatarUrl)
                : null,
            child: booking.user.avatarUrl.isEmpty
                ? Icon(Icons.person, size: 28.w, color: AppColors.textTernary)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.user.fullName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                Text(
                  booking.user.email,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textTernary,
                  ),
                ),
              ],
            ),
          ),
          // ── Status badge ──
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _statusColor(booking.status).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              booking.status.toUpperCase(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: _statusColor(booking.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending'    : return Colors.orange;
      case 'inspecting' : return Colors.blue;
      case 'repairing'  : return Colors.purple;
      case 'completed'  : return Colors.green;
      default           : return Colors.grey;
    }
  }
}

// ════════════════════════════════════════════════════════════
//  Step content
// ════════════════════════════════════════════════════════════
class _StepContent extends StatelessWidget {
  final BookingDetailModel booking;
  final int currentStep;
  const _StepContent({required this.booking, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return Text(
          '${booking.user.fullName} has started inspecting the car. '
              'Please allow some time while the inspection is being completed.',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
          textAlign: TextAlign.center,
        );
      case 1:
      case 2:
      case 3:
        return _BillingSection(booking: booking);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ════════════════════════════════════════════════════════════
//  Billing section — dynamic cost_details
// ════════════════════════════════════════════════════════════
class _BillingSection extends StatelessWidget {
  final BookingDetailModel booking;
  const _BillingSection({required this.booking});

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

          // ✅ cost_details dynamic rows
          ...booking.costDetails.entries.map((entry) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '\$${entry.value}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          )),

          const Divider(),
          SizedBox(height: 4.h),

          // ✅ Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                ),
              ),
              Text(
                '\$${booking.totalCost.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Action buttons by step
// ════════════════════════════════════════════════════════════
class _ActionButtons extends StatelessWidget {
  final int        currentStep;
  final VoidCallback onNext;
  final VoidCallback onCancel;
  final VoidCallback onPay;
  final TextStyle  cancelStyle;

  const _ActionButtons({
    required this.currentStep,
    required this.onNext,
    required this.onCancel,
    required this.onPay,
    required this.cancelStyle,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0: // pending — Next only
        return PrimaryButton(
          text: 'Next',
          borderColor: AppColors.textPrimary.withValues(alpha: 0.6),
          textStyle: cancelStyle,
          onTap: onNext,
        );

      case 1: // inspecting — Cancel + Next
        return Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Cancel',
                borderColor: AppColors.textPrimary.withValues(alpha: 0.6),
                textStyle: cancelStyle,
                onTap: onCancel,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: PrimaryButton(
                text: 'Next',
                backgroundColor: AppColors.primary,
                onTap: onNext,
              ),
            ),
          ],
        );

      case 2: // repairing — Next only
        return PrimaryButton(
          text: 'Next',
          borderColor: AppColors.textPrimary.withValues(alpha: 0.6),
          textStyle: cancelStyle,
          onTap: onNext,
        );

      case 3: // completed — Pay Now
        return PrimaryButton(
          text: 'Pay Now',
          backgroundColor: AppColors.primary,
          onTap: onPay,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}