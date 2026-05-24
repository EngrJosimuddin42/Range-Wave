import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/utils/color/app_colors.dart';
import '../../../../core/utils/common_widget/icon_container.dart';
import '../../../../gen/assets.gen.dart';

Widget mechanicCard({required bool isAccepted}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xFFD1D5DB)),
      color: Color(0xFFFEFEFE),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundImage: Assets.images.user.provider(),
          radius: 28.r,
        ),
        SizedBox(width: 12.w),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alexanders Lol',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Assets.icons.ratingFilled.svg(),
                SizedBox(width: 4.w),
                Text('4.5'),
              ],
            ),
          ],
        ),

        const Spacer(),

        //  onTap  ChatDetailScreen এ navigate
        if (isAccepted)
          GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.chatDetailScreen,
                arguments: {
                  'name': 'Alexanders Lol',
                  'imageUrl': Assets.images.user.path,
                },
              );
            },
            child: IconContainer(
              bgColor: AppColors.shadow.withValues(alpha: 0.1),
              path: Assets.icons.chat.path,
              width: 20.w,
              height: 20.w,
            ),
          ),
      ],
    ),
  );
}