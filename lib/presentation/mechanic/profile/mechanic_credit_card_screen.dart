import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class MechanicCreditCardScreen extends StatelessWidget {
  const MechanicCreditCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('payment'),
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Assets.images.paymentCard.image(
                width: double.infinity,
                height: 210.h,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 16.h),

            CustomTextField(
              controller: TextEditingController(),
              hintText: 'Card Holder',
            ),
            SizedBox(height: 12.h),
            CustomTextField(
              controller: TextEditingController(),
              hintText: 'Card Number',
            ),

            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'MM/YY',
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'CVV',
                  ),
                ),
              ],
            ),

            SizedBox(height: 50.h),
            PrimaryButton(
              text: 'Update',
              backgroundColor: AppColors.primary,
              onTap: () {
                Get.toNamed(AppRoutes.mechanicBottomNav);
              },
            ),
          ],
        ),
      ),
    );
  }
}
