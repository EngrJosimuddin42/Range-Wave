import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/utils/color/app_colors.dart';
import '../../../../core/utils/common_widget/app_title.dart';
import '../../../../core/utils/common_widget/primary_button.dart';
import '../../../../controller/service_in_progress_controller.dart';
import 'bill_row.dart';

Widget completeSection(ServiceInProgressController controller) {
  return Column(
    children: [
      AppTitle(title: 'Bill', isShowAll: false, onTap: () {}),
      SizedBox(height: 20.h),

      BillRow(title: 'Mechanic Arrived', time: '10.30 AM', price: '\$550'),
      SizedBox(height: 16.h),
      BillRow(title: 'Oil Changes', time: '10.55 AM', price: '\$123'),
      SizedBox(height: 16.h),
      BillRow(title: 'Break Pad', time: '11.00 AM', price: '\$550'),
      SizedBox(height: 16.h),
      BillRow(title: 'Extra Service Charge', time: '11.30 AM', price: '\$550'),
      SizedBox(height: 16.h),
      BillRow(
        title: 'Total',
        time: '10.30 AM',
        price: '\$550',
        isShowTime: false,
      ),
      SizedBox(height: 100.h), // shows when step >=2
      SizedBox(height: 16.h),
      Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: 'Cancel',
              borderColor: AppColors.textPrimary.withValues(alpha: 0.6),
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              onTap: () {
                Get.toNamed(AppRoutes.userBottomNav);
              },
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: PrimaryButton(
              text: 'Pay now',
              backgroundColor: AppColors.primary,
              onTap: () {
                Get.toNamed(AppRoutes.makePayment);
              },
            ),
          ),
        ],
      ),
    ],
  );
}
