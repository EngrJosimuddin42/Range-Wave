import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/payment_controller.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class UserPaymentScreen extends StatelessWidget {
  UserPaymentScreen({super.key});

  final PaymentController controller = Get.put( PaymentController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),

            // Dynamic card list
            Obx(() => Column(
              children: controller.paymentCards.asMap().entries.map((entry) {
                final index = entry.key;
                final card = entry.value;
                final isSelected = controller.selectedIndex.value == index;

                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: GestureDetector(
                    onTap: () => controller.selectCard(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.white,
                        border: Border.all(
                          //  Selected হলে border highlight
                          color: isSelected
                              ? AppColors.blue
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          //  Stripe/Apple Pay এর জন্য image, নতুন card এর জন্য icon
                          index == 0
                              ? Assets.images.stripe.image(width: 32.w)
                              : index == 1
                              ? Assets.images.applePay.image(width: 32.w)
                              : Icon(Icons.credit_card,
                              size: 32.w,
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
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),

            //  Add payment Card
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.creditCard);
              },
              child: Row(
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
            ),

            SizedBox(height: 50.h),

            PrimaryButton(
              text: 'Save Now',
              backgroundColor: AppColors.primary,
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}