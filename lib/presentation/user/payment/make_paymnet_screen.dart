import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/payment_controller.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class MakePaymentScreen extends StatelessWidget {
  MakePaymentScreen({super.key});

  //  PaymentController find করছে
  final PaymentController paymentController = Get.find<PaymentController>();

  final TextStyle labelStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.manrope().fontFamily,
    color: AppColors.textPrimary,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Bill Payment',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.manrope().fontFamily,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // ── Billing Summary ──
            Text(
              'Billing Summary',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.manrope().fontFamily,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Mechanic Name ──
                  Text(
                    'Alex Car Mechanic',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // ── Date & Time ──
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 14.w, color: AppColors.textSecondary),
                      SizedBox(width: 4.w),
                      Text(
                        'Dec 16, 2024',
                        style: labelStyle.copyWith(
                            color: AppColors.textSecondary),
                      ),
                      SizedBox(width: 12.w),
                      Icon(Icons.access_time,
                          size: 14.w, color: AppColors.textSecondary),
                      SizedBox(width: 4.w),
                      Text(
                        '10:00 AM',
                        style: labelStyle.copyWith(
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),
                  Divider(
                      color: AppColors.textPrimary.withValues(alpha: 0.1)),
                  SizedBox(height: 12.h),

                  // ── Bill Items ──
                  _billItem('Oil Changes', '\$123'),
                  SizedBox(height: 10.h),
                  _billItem('Break Pad', '\$123'),
                  SizedBox(height: 10.h),
                  _billItem('Extra Service Charge', '\$123'),

                  SizedBox(height: 12.h),
                  Divider(
                      color: AppColors.textPrimary.withValues(alpha: 0.1)),
                  SizedBox(height: 12.h),

                  // ── Total ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: labelStyle),
                      Text(
                        '\$2200',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: GoogleFonts.manrope().fontFamily,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ── Payment Method ──
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.manrope().fontFamily,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),

            // ✅ Dynamic card list
            Obx(() => Column(
              children: paymentController.paymentCards.asMap().entries.map((entry) {
                final index = entry.key;
                final card = entry.value;

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: GestureDetector(
                    onTap: () => paymentController.selectCard(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          // ✅ Stripe/Apple Pay image, নতুন card এ icon
                          index == 0
                              ? Assets.images.stripe.image(width: 24.w)
                              : index == 1
                              ? Assets.images.applePay.image(width: 24.w)
                              : Icon(Icons.credit_card,
                              size: 24.w,
                              color: AppColors.primary),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              card.cardNumber.isNotEmpty
                                  ? '**** **** **** ${card.cardNumber.length >= 4 ? card.cardNumber.substring(card.cardNumber.length - 4) : card.cardNumber}'
                                  : card.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.manrope().fontFamily,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          // ✅ Radio button
                          Obx(() => Radio(
                            value: index,
                            groupValue: paymentController.selectedIndex.value,
                            onChanged: (val) =>
                                paymentController.selectCard(val!),
                            activeColor: AppColors.primary,
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),

            SizedBox(height: 8.h),

            // ── Security Note ──
            Text(
              'Your payment information is secure and encrypted.\nBy confirming, you agree to our Terms of Service.',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.manrope().fontFamily,
                color: AppColors.textSecondary,
              ),
            ),

            const Spacer(),

            // ── Bottom Buttons ──
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Row(
                children: [
                  // Total button
                  Expanded(
                    child: PrimaryButton(
                      text: 'Total: \$2200',
                      borderColor:
                      AppColors.textPrimary.withValues(alpha: 0.3),
                      textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // Pay Now button
                  Expanded(
                    child: PrimaryButton(
                      text: 'Pay Now',
                      backgroundColor: AppColors.primary,
                      onTap: () {
                        Get.toNamed(AppRoutes.paymentSuccessful);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bill Item Row ──
  Widget _billItem(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: labelStyle),
        Text(price, style: labelStyle),
      ],
    );
  }
}