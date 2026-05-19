import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color/app_colors.dart';

class PaymentContainer extends StatelessWidget {
  final String image;
  final String label;

  const PaymentContainer({super.key, required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 1.w,
          color: AppColors.textPrimary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Image.asset(image, width: 32.w, height: 22.h, fit: BoxFit.contain),
          SizedBox(width: 10.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
