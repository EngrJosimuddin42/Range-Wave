import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/color/app_colors.dart';
import '../../../../gen/assets.gen.dart';

Widget certificateRow({required String title}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Assets.icons.certificate.svg(),
          SizedBox(width: 5.w),
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
      TextButton(
        onPressed: () {},
        child: Text(
          'View',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blue,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
      ),
    ],
  );
}
