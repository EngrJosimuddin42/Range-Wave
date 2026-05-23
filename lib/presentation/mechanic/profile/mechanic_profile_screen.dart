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
import '../../../controller/profile_controller.dart';
import '../../../core/utils/app_helper.dart';
import '../../../gen/assets.gen.dart';

class MechanicProfileScreen extends StatefulWidget {
  const MechanicProfileScreen({super.key});

  @override
  State<MechanicProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<MechanicProfileScreen> {
  late final ProfileController controller;
  bool isNotificationOn = false;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProfile();
    });
  }

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

      body: Obx(() {
        if (controller.isLoading.value && controller.mechanicData.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final name = controller.mechanicData['full_name'] ?? '';
        final email = controller.mechanicData['email'] ?? '';
        final serviceArea = controller.mechanicData['service_area'] ?? '';
        final imageUrl = controller.profileImageUrl.value;
        final rating   = controller.mechanicData['avg_rating']?.toString() ?? '0';
        final specialists = controller.specialistList.toList();

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                // Profile Card
                Container(
                  padding: EdgeInsets.only(top: 6.h),
                  decoration: BoxDecoration(color: AppColors.surface),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          image: imageUrl.isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: imageUrl.isEmpty
                            ? Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      SizedBox(width: 16.w),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Icon(
                                  Icons.star_rounded,
                                  color: const Color(0xFFFFA726),
                                  size: 16.w,
                                ),
                                SizedBox(width: 2.w),
                                Text(  rating,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.manrope().fontFamily,
                                color: AppColors.textPrimary.withValues(alpha: 0.6),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              serviceArea,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8A8D9F),
                              ),
                            ),
                            const Divider(),
                            SizedBox(height: 8.h),
                            Text( 'Specialist',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.manrope().fontFamily,
                                color: AppColors.textPrimary.withValues(alpha: 0.8),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: specialists
                                  .map((s) => ChipsButton(title: s))
                                  .toList(),
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

                const SizedBox(height: 16),

                Column(
                  children: [
                    settingsOption(
                      icon: Assets.icons.notification.path,
                      label: 'Push Notification',
                      onTap: () {},
                      isShowSwitchButton: true,
                      switchValue: isNotificationOn,
                      onSwitchChanged: (value) {
                        setState(() {
                          isNotificationOn = value;
                        });
                      },
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
                      onTap: () => _showLogoutSheet(context),
                      isShowSwitchButton: false,
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }


  void _showLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Container(
          height: 250.h,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 24.sp,
                  color: AppColors.red,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                ),
              ),
              SizedBox(height: 20.h),
              const Divider(),
              SizedBox(height: 20.h),
              Text(
                'Are you sure you want to log out?',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      borderRadius: BorderRadius.circular(50.r),
                      text: 'Yes',
                      borderColor: AppColors.textPrimary.withValues(alpha: 0.5),
                      textStyle: TextStyle(color: AppColors.textPrimary),
                      onTap: () async {
                        await AppHelper.instance.clearAll();
                        Get.delete<SignInController>();
                        Get.delete<ProfileController>();
                        Get.toNamed(AppRoutes.selectUser);
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: PrimaryButton(
                      borderRadius: BorderRadius.circular(50.r),
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
  }

  Widget settingsOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required bool isShowSwitchButton,
    bool switchValue = true,
    ValueChanged<bool>? onSwitchChanged,
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
              ? GestureDetector(
            onTap: () {
              if (onSwitchChanged != null) {
                onSwitchChanged(!switchValue);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 38.w,
              height: 20.h,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: switchValue
                          ? AppColors.blue
                          : const Color(0xFF8A8A8A),
                      width: .5),
                  borderRadius: BorderRadius.circular(20.r),
                  color: switchValue
                      ? AppColors.blue
                      : Colors.white),
              alignment: switchValue ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: switchValue
                      ? Colors.white
                      : const Color(0xFFB0B0B0),
                ),
              ),
            ),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}