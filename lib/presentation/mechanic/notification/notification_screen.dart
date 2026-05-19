import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/utils/common_widget/icon_container.dart';

import '../../../core/utils/color/app_colors.dart';
import '../../../gen/assets.gen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Notifications'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text(
              'Mark all as read',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.blue,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today'),
            NotificationCard(
              notificationMessage:
                  'New Booking request is waiting for your approval.',
              dateTime: '1 jan 2026 at 10.10 am',
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String notificationMessage;
  final String dateTime;

  const NotificationCard({
    super.key,
    required this.notificationMessage,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        notificationMessage,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
      ),
      subtitle: Text(
        dateTime,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
      ),
      leading: IconContainer(
        path: Assets.icons.delivery.path,
        bgColor: AppColors.orangeLight,
      ),
    );
  }
}
