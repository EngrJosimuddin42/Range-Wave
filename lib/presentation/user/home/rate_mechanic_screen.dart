import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/custom_text_field.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class RateMechanicScreen extends StatefulWidget {
  const RateMechanicScreen({super.key});

  @override
  State<RateMechanicScreen> createState() => _RateMechanicScreenState();
}

class _RateMechanicScreenState extends State<RateMechanicScreen> {
  int selectedRating = 4; // ✅ Default 4 stars
  final reviewController = TextEditingController();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Rate the Mechanic',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.h),

            // ── Mechanic Info ──
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: Assets.images.user.provider(),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Alexanders Lol',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ✅ Interactive star rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final isFilled = index < selectedRating;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Assets.icons.ratingFilled.svg(
                            width: 40.w,
                            height: 40.w,
                            fit: BoxFit.contain,
                            //  Selected → orange, Unselected → grey
                            colorFilter: ColorFilter.mode(
                              isFilled
                                  ? AppColors.primary
                                  : AppColors.textSecondary.withValues(
                                  alpha: 0.3),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // ── Review Text ──
            Text(
              'Tell Something about our service',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
            SizedBox(height: 12.h),

            // ✅ Multi-line text field
            CustomTextField(
              controller: reviewController,
              hintText: 'Any special requirements or notes for the mechanic...',
              maxLines: 5,
              minLines: 5,
              keyboardType: TextInputType.multiline,
            ),

            const Spacer(),

            // ── Submit Button ──
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: PrimaryButton(
                text: 'Submit',
                backgroundColor: AppColors.primary,
                onTap: () {
                  Get.offAllNamed(AppRoutes.userBottomNav);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}