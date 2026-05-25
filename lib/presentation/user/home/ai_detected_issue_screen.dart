import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/gen/assets.gen.dart';
import 'package:range_wave/model/car_issue_model.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/app_top_section.dart';
import '../../../core/utils/common_widget/primary_button.dart';

class AiDetectedIssueScreen extends StatelessWidget {
  const AiDetectedIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final CarIssueModel data = Get.arguments as CarIssueModel;

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

                  // ── Top bar ──────────────────────────────────
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      SizedBox(width: 8.w),
                      Text('Scheduled a Service',
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

                  // ── AI Summary card ──────────────────────────
                  Container(
                    padding: EdgeInsets.all(12.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.r,
                          offset: const Offset(0, 4),
                          color: AppColors.shadow.withValues(alpha: 0.1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Header: title + issue badge ──────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('AI Summary',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: GoogleFonts.manrope().fontFamily,
                              ),
                            ),

                            //  Dynamic issue badge
                            if (data.issue.isNotEmpty &&
                                data.issue.toLowerCase() != 'none')
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 4.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: _issueBgColor(data.severityLevel),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                      color: AppColors.textPrimary
                                          .withValues(alpha: 0.15),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  data.issue,
                                  style: TextStyle(
                                    color: _issueTextColor(data.severityLevel),
                                    fontSize: 14.sp,
                                    fontFamily:
                                    GoogleFonts.manrope().fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            else
                            // issue না থাকলে "No Issue" badge
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 4.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: const Color(0xFFD3F4DE),
                                ),
                                child: Text( 'No Issue',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 14.sp,
                                    fontFamily:
                                    GoogleFonts.manrope().fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        //  Dynamic confidence circle
                        _CircleSection(confidence: data.confidenceLevel),

                        SizedBox(height: 12.h),

                        //  Dynamic severity level
                        InfoStatus(
                          title: 'Severity Level',
                          value: data.severityLevel.isEmpty ||
                              data.severityLevel.toLowerCase() == 'none'
                              ? 'N/A'
                              : data.severityLevel,
                          dotColor: _severityColor(data.severityLevel),
                        ),

                        SizedBox(height: 8.h),
                        const Divider(),
                        SizedBox(height: 8.h),

                        //  Dynamic summary text
                        Text(
                          data.summary.isEmpty ||
                              data.summary == 'response.output_text'
                              ? 'No summary available.'
                              : data.summary,
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
                    text: 'View Recommended Mechanics',
                    backgroundColor: AppColors.primary,
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.recommendedMatches,
                        arguments: data,
                      );
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

  // ── Color helpers ────────────────────────────────────────

  Color _severityColor(String level) {
    switch (level.toLowerCase()) {
      case 'serious':
      case 'critical':
        return Colors.red;
      case 'moderate':
      case 'medium':
        return Colors.orange;
      case 'minor':
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _issueBgColor(String level) {
    switch (level.toLowerCase()) {
      case 'serious':
      case 'critical':
        return const Color(0xFFFFE5E5);
      case 'moderate':
      case 'medium':
        return const Color(0xFFFFF3E0);
      default:
        return const Color(0xFFD3F4DE);
    }
  }

  Color _issueTextColor(String level) {
    switch (level.toLowerCase()) {
      case 'serious':
      case 'critical':
        return Colors.red;
      case 'moderate':
      case 'medium':
        return Colors.orange;
      default:
        return AppColors.green;
    }
  }
}

// ════════════════════════════════════════════════════════════
//  Confidence circle — dynamic
// ════════════════════════════════════════════════════════════
class _CircleSection extends StatelessWidget {
  final int confidence;
  const _CircleSection({required this.confidence});

  @override
  Widget build(BuildContext context) {
    final String label = '$confidence%';
    final double leftOffset = label.length <= 3 ? 45.w : 38.w;

    return Center(
      child: Stack(
        children: [
          Assets.images.stylishCircle.image(
            width: 110.w,
            height: 110.w,
            fit: BoxFit.contain),
          Positioned(
            top: 35.h,
            left: leftOffset,
            child: Text(
              label,
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
}

// ════════════════════════════════════════════════════════════
//  InfoStatus row
// ════════════════════════════════════════════════════════════
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