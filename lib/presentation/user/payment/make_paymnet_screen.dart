import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/app_top_section.dart';
import '../../../core/utils/common_widget/payment_container.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class MakePaymentScreen extends StatelessWidget {
  const MakePaymentScreen({super.key});

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
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Payment',
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.icons.moneyNotes.svg(
                          height: 32.w,
                          width: 32.w,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          'USD \$100.00',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 28.h),
                    AppTitle(
                      title: 'Payment methods',
                      isShowAll: false,
                      onTap: () {},
                    ),

                    SizedBox(height: 16.h),
                    PaymentContainer(
                      image: Assets.images.stripe.path,
                      label: 'Stripe',
                    ),
                    SizedBox(height: 16.h),
                    PaymentContainer(
                      image: Assets.images.applePay.path,
                      label: 'Apple Pay',
                    ),

                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Icon(Icons.add, size: 24.w),
                        SizedBox(width: 6.w),
                        Text(
                          'Add payment Card',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),
                    PrimaryButton(
                      text: 'Next',
                      backgroundColor: AppColors.primary,
                      onTap: () {
                        Get.toNamed(AppRoutes.paymentSuccessful);
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
