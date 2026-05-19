import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/color/app_colors.dart';

class BillRow extends StatelessWidget {
  final String title;
  final String time;
  final String price;
  final bool isShowTime;

  const BillRow({
    super.key,
    required this.title,
    required this.time,
    required this.price,
    this.isShowTime = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.greenLight,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (isShowTime)
              Text(
                time,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textPrimary,
                ),
              ),
            SizedBox(width: 10.w),
            Text(
              price,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
