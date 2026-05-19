import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/gen/assets.gen.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/app_top_section.dart';
import '../../../core/utils/common_widget/primary_button.dart';

class AiDetectedIssueScreen extends StatelessWidget {
  const AiDetectedIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopLogo(),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.arrow_back),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Scheduled a Service',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          fontFamily: GoogleFonts.manrope().fontFamily,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.r,
                          offset: Offset(0, 4),
                          color: AppColors.shadow.withValues(alpha: 0.1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('AI Summery'),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 4.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: Color(0xFFD3F4DE),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                    color: AppColors.textPrimary.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Break Issue',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 16.sp,
                                  fontFamily: GoogleFonts.manrope().fontFamily,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        _circleSection(),
                        SizedBox(height: 12.h),
                        InfoStatus(
                          title: 'Severity Level',
                          value: 'Serious',
                          dotColor: Colors.red,
                        ),
                        // SizedBox(height: 8.h),
                        // Divider(),
                        // SizedBox(height: 8.h),
                        // InfoStatus(
                        //   title: 'Estimate Amount',
                        //   value: '\$1250',
                        //   dotColor: Colors.green,
                        // ),
                        SizedBox(height: 8.h),
                        Divider(),
                        SizedBox(height: 8.h),
                        Text(
                          'Quick Suggestion: Avoid diving long distances. Professional inspection is highly recommended.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 50.h),
                  PrimaryButton(
                    text: 'View Recommended Mechanics ',
                    backgroundColor: AppColors.primary,
                    onTap: () {
                      Get.toNamed(AppRoutes.recommendedMatches);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _circleSection() {
  return Center(
    child: Stack(
      children: [
        Assets.images.stylishCircle.image(
          width: 110.w,
          height: 110.w,
          fit: BoxFit.contain,
        ),
        Positioned(
          top: 35.h,
          left: 45.w,
          child: Text(
            '70%',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blue,
            ),
          ),
        ),
        Positioned(
          top: 60.h,
          left: 25.w,
          child: Text(
            'Confidence',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
        ),
      ],
    ),
  );
}

class InfoStatus extends StatelessWidget {
  final String title;
  final String value;
  final Color dotColor;

  const InfoStatus({
    super.key,
    required this.title,
    required this.value,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Row(
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              value,
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
