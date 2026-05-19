import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/app_top_section.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class RateMechanicScreen extends StatelessWidget {
  const RateMechanicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopLogo(),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Rate the  Mechanic',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 28.h),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.r,
                        vertical: 12.h,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          width: 1.w,
                          color: AppColors.textPrimary.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 26.r,
                            backgroundImage: Assets.images.user.provider(),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Alexanders Lol',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              fontFamily: GoogleFonts.manrope().fontFamily,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.ratingFilled.svg(
                                width: 18.w,
                                height: 18.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '4',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontFamily: GoogleFonts.manrope().fontFamily,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '(15 reviews)',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              // if (controller.selectedIndex.contains(index)) {
                              //   controller.selectedIndex.remove(index);
                              //   return;
                              // } else {
                              //   controller.selectedIndex.add(index);
                              // }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 11.w),
                              child: Assets.icons.ratingFilled.svg(
                                width: 44.w,
                                height: 44.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),

                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: 'Later',
                            borderColor: AppColors.textPrimary.withValues(
                              alpha: 0.6,
                            ),
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.chatDetailScreen,
                                arguments: {'name': 'Abid'},
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Save',
                            backgroundColor: AppColors.primary,
                            onTap: () {
                              Get.offAllNamed(AppRoutes.userBottomNav);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
