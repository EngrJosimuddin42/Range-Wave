import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/color/app_colors.dart';

class InfoShow extends StatelessWidget {
  final String title;
  final String value;

  const InfoShow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
        SizedBox(width: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
      ],
    );
  }
}
