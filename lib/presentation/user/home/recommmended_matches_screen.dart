import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/controller/recommended_mechanic_controller.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/model/recommended_mechanic_model.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/app_top_section.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/car_issue_model.dart';

class RecommendedMatchesScreen extends StatelessWidget {
  RecommendedMatchesScreen({super.key});

  final RecommendedMechanicController controller =
  Get.put(RecommendedMechanicController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopLogo(),

            // ── Top bar ──────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 8.w),
                  Text( 'Recommended Matches',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                ],
              ),
            ),

            // ── List ─────────────────────────────────────────
            Expanded(
              child: Obx(() {

                // Loading
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                // Empty
                if (controller.mechanicList.isEmpty) {
                  return Center(
                    child: Text(
                      'No mechanics found.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textTernary,
                      ),
                    ),
                  );
                }

                // List
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.mechanicList.length,
                  itemBuilder: (context, index) {
                    final match = controller.mechanicList[index];
                    return _MatchTile(
                      match        : match,
                      isHighlighted: index == 0,
                      onTap: () => Get.toNamed(
                        AppRoutes.mechanicPortfolio,
                        arguments: {
                          'mechanic' : match,
                          'issue_id' : (Get.arguments as CarIssueModel).id,
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Match tile
// ════════════════════════════════════════════════════════════
class _MatchTile extends StatelessWidget {
  final RecommendedMechanicModel match;
  final bool         isHighlighted;
  final VoidCallback onTap;

  const _MatchTile({
    required this.match,
    required this.isHighlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isHighlighted
              ? AppColors.blue.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w),

          // ── Avatar ────────────────────────────────────────
          leading: CircleAvatar(
            radius: 28.r,
            backgroundColor: AppColors.surface,
            backgroundImage: match.avatarUrl.isNotEmpty
                ? NetworkImage(match.avatarUrl)
                : null,
            child: match.avatarUrl.isEmpty
                ? Icon(
              Icons.person,
              size: 28.w,
              color: AppColors.textTernary,
            )
                : null,
          ),

          // ── Name ──────────────────────────────────────────
          title: Text(
            match.fullName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),

          // ── Distance & shop name ───────────────────────────
          subtitle: Text(
            '${match.distanceKm.toStringAsFixed(1)} km • ${match.shopName}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textTernary,
              fontWeight: FontWeight.w400,
            ),
          ),

          // ── Initial charge & rating ────────────────────────
          trailing: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${match.initialCharge}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.icons.ratingFilled.svg(
                      width: 20.w,
                      height: 20.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      match.avgRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}