import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color/app_colors.dart';

class AppTitle extends StatelessWidget {
  final String title;
  final bool isShowAll;
  final VoidCallback onTap;

  const AppTitle({
    super.key,
    required this.title,
    required this.isShowAll,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontStyle: GoogleFonts.manrope().fontStyle,
          ),
        ),
        Spacer(),
        if (isShowAll)
          InkWell(
            onTap: onTap,
            child: Text(
              'See All',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
                fontStyle: GoogleFonts.manrope().fontStyle,
              ),
            ),
          ),
      ],
    );
  }
}
