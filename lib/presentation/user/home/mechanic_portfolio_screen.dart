import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/controller/mechanic_portfolio_controller.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'package:range_wave/core/utils/common_widget/icon_container.dart';
import 'package:range_wave/model/mechanic_portfolio_model.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/common_widget/chips_button.dart';
import '../../../core/utils/common_widget/primary_button.dart';
import '../../../gen/assets.gen.dart';

class MechanicPortfolioScreen extends StatelessWidget {
  MechanicPortfolioScreen({super.key});

  final MechanicPortfolioController controller =
  Get.put(MechanicPortfolioController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Obx(() {

        // ── Loading ───────────────────────────────────────
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // ── No data ───────────────────────────────────────
        if (controller.mechanic.value == null) {
          return Center(
            child: Text(
              'Mechanic not found.',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textTernary),
            ),
          );
        }

        final m = controller.mechanic.value!;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Cover + Avatar ────────────────────────────
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
                      onTap: () => Get.back(),
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
                        backgroundColor: AppColors.surface,
                        backgroundImage: m.avatarUrl.isNotEmpty
                            ? NetworkImage(m.avatarUrl)
                            : null,
                        child: m.avatarUrl.isEmpty
                            ? Icon(Icons.person,
                            size: 50, color: AppColors.textTernary)
                            : null,
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

                    // ── Name ──────────────────────────────
                    Center(
                      child: Text(
                        m.fullName,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: GoogleFonts.manrope().fontFamily,
                        ),
                      ),
                    ),

                    // ── Rating ────────────────────────────
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
                          m.avgRating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '(${m.totalRating})',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary.withValues(alpha: 0.5),
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // ── Info card ─────────────────────────
                    _InfoCard(mechanic: m),

                    SizedBox(height: 30.h),

                    // ── Certifications ────────────────────
                    if (m.certificates.isNotEmpty) ...[
                      AppTitle(
                        title: 'Certifications',
                        isShowAll: false,
                        onTap: () {},
                      ),
                      ...m.certificates.map(
                            (cert) => _CertificateRow(cert: cert),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // ── Specialties ───────────────────────
                    if (m.specialist.isNotEmpty) ...[
                      AppTitle(
                        title: 'Specialties',
                        isShowAll: false,
                        onTap: () {},
                      ),
                      SizedBox(height: 12.h),
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
                              offset: const Offset(0, 1),
                              color: AppColors.textPrimary
                                  .withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                        child: Wrap(
                          spacing: 16.w,
                          runSpacing: 12.h,
                          children: m.specialist
                              .map((s) => ChipsButton(title: s))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],

                    // ── Location ──────────────────────────
                    AppTitle(
                      title: 'Location',
                      isShowAll: false,
                      onTap: () {},
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      m.shopName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Lat: ${m.latitude}, Lng: ${m.longitude}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textTernary,
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // ── Book Now ──────────────────────────
                    PrimaryButton(
                      text: 'Book Now',
                      backgroundColor: AppColors.primary,
                      onTap: () => Get.toNamed(
                        AppRoutes.mapScreen,
                        arguments: {
                          'mechanic' : m,
                          'issue_id' : controller.carIssueId,
                        },
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Info card — experience, charge, shop
// ════════════════════════════════════════════════════════════
class _InfoCard extends StatelessWidget {
  final MechanicPortfolioModel mechanic;
  const _InfoCard({required this.mechanic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.r,
            offset: const Offset(0, 2),
            color: AppColors.textPrimary.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoItem(
            label: 'Experience',
            value: '${mechanic.yearOfExperience} yrs',
          ),
          _Divider(),
          _InfoItem(
            label: 'Initial Charge',
            value: '\$${mechanic.initialCharge}',
          ),
          _Divider(),
          _InfoItem(
            label: 'Projects',
            value: mechanic.totalRating.toString(),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textTernary,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36.h,
      color: AppColors.textTernary.withValues(alpha: 0.3),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Certificate row
// ════════════════════════════════════════════════════════════
class _CertificateRow extends StatelessWidget {
  final MechanicCertificate cert;
  const _CertificateRow({required this.cert});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 2.r,
            offset: const Offset(0, 1),
            color: AppColors.textPrimary.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.network(
              cert.certificateImageUrl,
              width: 48.w,
              height: 40.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 48.w,
                height: 40.h,
                color: AppColors.surface,
                child: Icon(Icons.image_not_supported,
                    size: 20, color: AppColors.textTernary),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Certificate',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
          ),
          Icon(Icons.verified, color: AppColors.blue, size: 20.w),
        ],
      ),
    );
  }
}