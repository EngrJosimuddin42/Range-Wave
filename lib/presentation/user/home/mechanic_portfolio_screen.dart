import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'package:range_wave/core/utils/common_widget/icon_container.dart';
import 'package:range_wave/presentation/user/home/widget/certificate_card.dart';
import 'package:range_wave/presentation/user/home/widget/info_card.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/common_widget/chips_button.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class MechanicPortfolioScreen extends StatelessWidget {
  const MechanicPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Assets.images.coverMechanic.image(
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40.h,
                  left: 20.w,
                  child: IconContainer(
                    path: Assets.icons.back.path,
                    width: 40.w,
                    height: 38.h,
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundImage: Assets.images.user.provider(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Alexanders Lol',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.icons.ratingFilled.svg(
                        width: 16.w,
                        height: 16.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '4.9',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: GoogleFonts.manrope().fontFamily,
                        ),
                      ),
                      SizedBox(width: 3.w),

                      Text(
                        '(3,657)',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary.withValues(alpha: 0.5),
                          fontFamily: GoogleFonts.manrope().fontFamily,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  infoCard(),

                  SizedBox(height: 30),
                  AppTitle(
                    title: 'Certifications',
                    isShowAll: false,
                    onTap: () {},
                  ),
                  certificateRow(title: 'Technician Certificate'),
                  certificateRow(title: 'Vehicle Mechanic'),
                  certificateRow(title: 'Automobile Maintenance'),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.4.r,
                          offset: Offset(0, 1),
                          color: AppColors.textPrimary.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                    child: Wrap(
                      spacing: 16.w,
                      runSpacing: 12.h,
                      children: [
                        ChipsButton(title: 'Engine & Performance'),
                        ChipsButton(title: 'Gearbox'),
                        ChipsButton(title: 'Electrical & Electronics'),
                        ChipsButton(title: 'Brake System'),
                        ChipsButton(title: 'Air Conditioning (AC)'),
                        ChipsButton(title: 'Tyres & Wheels'),
                        ChipsButton(title: 'Suspension & Steering'),
                        ChipsButton(title: 'General '),
                        ChipsButton(title: 'Bodywork & Exterior'),
                        ChipsButton(title: 'Transmission'),
                        ChipsButton(title: 'Exhaust & Emission'),
                        ChipsButton(title: 'Gearbox'),
                        ChipsButton(title: 'Engine & Performance'),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),

                  AppTitle(title: 'Location', isShowAll: false, onTap: () {}),
                  SizedBox(height: 16.h),
                  Text('Kalorama Heights - W14 02 - Washington - USA'),

                  SizedBox(height: 28.h),

                  PrimaryButton(
                    text: 'Book Now',
                    backgroundColor: AppColors.primary,
                    onTap: () {
                      Get.toNamed(AppRoutes.mapScreen);
                    },
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
