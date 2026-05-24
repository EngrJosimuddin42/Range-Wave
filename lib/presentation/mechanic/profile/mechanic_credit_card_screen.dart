import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import '../../../controller/payment_controller.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class MechanicCreditCardScreen extends StatefulWidget {
  const MechanicCreditCardScreen({super.key});

  @override
  State<MechanicCreditCardScreen> createState() =>
      _MechanicCreditCardScreenState();
}

class _MechanicCreditCardScreenState extends State<MechanicCreditCardScreen> {
  final cardHolderController = TextEditingController();
  final cardNumberController = TextEditingController();
  final mmyyController = TextEditingController();
  final cvvController = TextEditingController();

  final PaymentController paymentController = Get.find<PaymentController>();

  @override
  void dispose() {
    cardHolderController.dispose();
    cardNumberController.dispose();
    mmyyController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void _onUpdate() {
    if (cardHolderController.text.trim().isEmpty ||
        cardNumberController.text.trim().isEmpty ||
        mmyyController.text.trim().isEmpty ||
        cvvController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    paymentController.addCard(
      holderName: cardHolderController.text.trim(),
      cardNumber: cardNumberController.text.trim(),
      mmyy: mmyyController.text.trim(),
    );

    Get.back();

    Get.snackbar(
      'Success',
      'Card added successfully',
      backgroundColor: AppColors.primary,
      colorText: AppColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Add Card'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
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
              controller: cardHolderController,
              hintText: 'Card Holder',
            ),
            SizedBox(height: 12.h),

            CustomTextField(
              controller: cardNumberController,
              hintText: 'Card Number',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: mmyyController,
                    hintText: 'MM/YY',
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomTextField(
                    controller: cvvController,
                    hintText: 'CVV',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            SizedBox(height: 50.h),

            PrimaryButton(
              text: 'Update',
              backgroundColor: AppColors.primary,
              onTap: _onUpdate,
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}