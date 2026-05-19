import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/chips_button.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/controller/sign_in_controller.dart';

import '../../../gen/assets.gen.dart';

class MechanicProfileScreen extends StatefulWidget {
  const MechanicProfileScreen({super.key});

  @override
  State<MechanicProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<MechanicProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Profile',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: <Widget>[
              // Profile Card
              Container(
                padding: EdgeInsets.only(top: 6.h),
                decoration: BoxDecoration(color: AppColors.surface),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://i.pravatar.cc/150?img=52',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Randy Orton',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFA726),
                                size: 16.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '5.0',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'daniel_austin@yourdomain.com',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.manrope().fontFamily,
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          const Text(
                            'Badd Link road, Dhaka 1212',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8D9F),
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 8.h),
                          Text(
                            'Specialist',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.manrope().fontFamily,
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),

                          Row(
                            children: [
                              ChipsButton(title: 'Engine repair'),
                              SizedBox(width: 10.w),
                              ChipsButton(title: 'Brakes'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Edit button
                    IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.mechanicEditProfile);
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 24.w,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Menu Items
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(children: []),
              ),

              const SizedBox(height: 16),

              Column(
                children: [
                  settingsOption(
                    icon: Assets.icons.notification.path,
                    label: 'Push Notification',
                    onTap: () {},
                    isShowSwitchButton: true,
                  ),
                  SizedBox(height: 20.h),
                  settingsOption(
                    icon: Assets.icons.payment.path,
                    label: 'Payment',
                    onTap: () {
                      Get.toNamed(AppRoutes.mechanicPayment);
                    },
                    isShowSwitchButton: false,
                  ),
                  SizedBox(height: 20.h),
                  settingsOption(
                    icon: Assets.icons.car.path,
                    label: 'Set time',
                    onTap: () {
                      Get.toNamed(AppRoutes.setTime);
                    },
                    isShowSwitchButton: false,
                  ),
                  SizedBox(height: 20.h),
                  settingsOption(
                    icon: Assets.icons.lock.path,
                    label: 'Change Password',
                    onTap: () {
                      Get.toNamed(AppRoutes.mechanicChangePassword);
                    },
                    isShowSwitchButton: false,
                  ),
                  SizedBox(height: 20.h),
                  settingsOption(
                    icon: Assets.icons.privacy.path,
                    label: 'Payment History',
                    onTap: () {
                      Get.toNamed(AppRoutes.mechanicPaymentHistory);
                    },
                    isShowSwitchButton: false,
                  ),
                  SizedBox(height: 20.h),
                  settingsOption(
                    icon: Assets.icons.privacy.path,
                    label: 'Privacy Policy',
                    onTap: () {
                      Get.toNamed(AppRoutes.userPrivacy);
                    },
                    isShowSwitchButton: false,
                  ),
                  SizedBox(height: 20.h),
                  settingsOption(
                    icon: Assets.icons.logout.path,
                    label: 'Log Out',
                    onTap: () {
                      showModalBottomSheet(
                        showDragHandle: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 250.h,
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: AppColors.red,
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        GoogleFonts.manrope().fontFamily,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Divider(),
                                SizedBox(height: 20.h),
                                Text(
                                  'Are you sure you want to log out?',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                        GoogleFonts.manrope().fontFamily,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: PrimaryButton(
                                        borderRadius: BorderRadius.circular(
                                          50.r,
                                        ),
                                        text: 'Yes',
                                        borderColor: AppColors.textPrimary
                                            .withValues(alpha: 0.5),
                                        textStyle: TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                        onTap: () {
                                          Get.delete<SignInController>();
                                          Get.toNamed(AppRoutes.selectUser);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: PrimaryButton(
                                        borderRadius: BorderRadius.circular(
                                          50.r,
                                        ),
                                        text: 'No',
                                        backgroundColor: AppColors.primary,
                                        onTap: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    isShowSwitchButton: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingsOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required bool isShowSwitchButton,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 24.w,
                height: 24.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 13.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          isShowSwitchButton
              ? Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                  inactiveTrackColor: AppColors.white,
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
