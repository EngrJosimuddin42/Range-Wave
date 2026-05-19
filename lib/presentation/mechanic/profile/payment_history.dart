import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:range_wave/gen/assets.gen.dart';

import '../../../core/utils/color/app_colors.dart';

class PaymentHistory extends StatelessWidget {
  PaymentHistory({super.key});

  // final PaymentHistoryController paymentHistoryController =
  // Get.find<PaymentHistoryController>();

  final _header = SafeArea(
    bottom: false,
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.border,
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 16.w,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        Spacer(flex: 1),
        Text(
          'Payment History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(flex: 2),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.surface,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _header,
              SizedBox(height: 6.h),
              ListTile(
                title: Text('Wedding Photography'),
                subtitle: Text('ID : BCFG354JUYHG'),
                trailing: Text('-\$1500'),
                leading: Assets.icons.stripePay.svg(
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
