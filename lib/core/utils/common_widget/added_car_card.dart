import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../gen/assets.gen.dart';
import '../color/app_colors.dart';

class AddedCarCard extends StatelessWidget {
  final String carName;
  final String carModel;
  final String image;

  const AddedCarCard({
    super.key,
    required this.carName,
    required this.carModel,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 219.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image.isEmpty
              ? Assets.images.car1.image(
                  width: 219.w,
                  height: 82.h,
                  fit: BoxFit.cover,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child: Image.network(
                    image,
                    width: 219.w,
                    height: 93.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 219.w,
                        height: 93.h,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2.w,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Assets
                        .images
                        .car1
                        .image(width: 219.w, height: 93.h, fit: BoxFit.cover),
                  ),
                ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: GoogleFonts.manrope().fontStyle,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    carModel,
                    style: TextStyle(
                      color: AppColors.textTernary.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: GoogleFonts.manrope().fontStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
