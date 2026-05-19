import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/color/app_colors.dart';
import 'info_show.dart';

Widget infoCard() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      color: AppColors.white,
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InfoShow(title: 'AI Verified Matched', value: '90%'),
            InfoShow(title: 'Average Pricing', value: '\$1200'),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InfoShow(title: 'Experience', value: '15 years'),
            SizedBox(width: 40.w),
            InfoShow(title: 'Price Range', value: '\$150-\$500'),
          ],
        ),
      ],
    ),
  );
}
