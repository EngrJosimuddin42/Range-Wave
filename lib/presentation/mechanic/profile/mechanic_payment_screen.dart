import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/payment_container.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class MechanicPaymentScreen extends StatelessWidget {
  const MechanicPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),

            PaymentContainer(image: Assets.images.stripe.path, label: 'Stripe'),
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

            SizedBox(height: 50.h),
            PrimaryButton(
              text: 'Save Changes',
              backgroundColor: AppColors.primary,
              onTap: () {
                Get.toNamed(AppRoutes.mechanicCreditCard);
              },
            ),
          ],
        ),
      ),
    );
  }
}
