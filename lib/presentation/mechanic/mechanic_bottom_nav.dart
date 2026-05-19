import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/presentation/chat/chat_list_screen.dart';
import 'package:range_wave/presentation/mechanic/history/mechanic_history_screen.dart';
import 'package:range_wave/presentation/mechanic/home/mechanic_home_screen.dart';
import 'package:range_wave/presentation/mechanic/profile/mechanic_profile_screen.dart';
import '../../gen/assets.gen.dart';

class MechanicBottomNav extends StatefulWidget {
  const MechanicBottomNav({super.key});

  @override
  State<MechanicBottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<MechanicBottomNav> {
  int currentIndex = 0;

  List<Widget> pages = [
    MechanicHomeScreen(),
    ChatListScreen(),
    MechanicHistoryScreen(),
    MechanicProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        currentIndex: currentIndex,
        backgroundColor: AppColors.surface,
        unselectedItemColor: AppColors.textPrimary,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedFontSize: 13.sp,
        selectedFontSize: 13.sp,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 5.h),
              child: Assets.icons.home.svg(
                width: 22.w,
                height: 22.h,
                fit: BoxFit.cover,
              ),
            ),
            label: 'Home',
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 5.h),
              child: Assets.icons.homeFilled.svg(
                color: AppColors.primary,
                width: 22.w,
                height: 22.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 5.h),
              child: Assets.icons.chat.svg(
                width: 22.w,
                height: 22.h,
                fit: BoxFit.cover,
              ),
            ),
            label: 'Chat',
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 5.h),
              child: Assets.icons.chat.svg(
                color: AppColors.primary,
                width: 22.w,
                height: 22.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 5.h),
              child: Assets.icons.clock.svg(
                color: AppColors.textPrimary,
                width: 22.w,
                height: 22.h,
                fit: BoxFit.cover,
              ),
            ),
            label: 'History',
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 5.h),
              child: Assets.icons.clockFilled.svg(
                width: 22.w,
                height: 22.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 5.h),
              child: Assets.icons.profile.svg(
                width: 22.w,
                height: 22.h,
                fit: BoxFit.cover,
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 5.h),
              child: Assets.icons.profileFilled.svg(
                color: AppColors.primary,
                width: 22.w,
                height: 22.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
