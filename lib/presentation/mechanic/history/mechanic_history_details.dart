import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';

import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/icon_container.dart';
import '../../../gen/assets.gen.dart';

class MechanicHistoryDetails extends StatelessWidget {
  const MechanicHistoryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Civic Honda'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Text('(2 days left)'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: Assets.images.user.provider(),
                          radius: 28.r,
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alexanders Lol',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: GoogleFonts.manrope().fontFamily,
                              ),
                            ),
                            SizedBox(height: 4.h),

                            Text('Badd Link Road'),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Assets.icons.ratingFilled.svg(),
                                SizedBox(width: 3.w),
                                Text('20 min'),
                                Text('• 12km'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Said',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'A flat tire occurs when a tire loses all or most of its air pressure, causing it to become deflated. This can happen due to punctures, leaks, or damage to the tire, making it unsafe or impossible to drive until repaired or replaced. A flat tire often results in a noticeable loss of vehicle control and may cause a bumpy or uneven ride.',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              AppTitle(title: 'Details', isShowAll: false, onTap: () {}),
              SizedBox(height: 16.h),

              DetailsServiceCard(title: 'Service Charge', price: '420'),

              SizedBox(height: 12.h),
              DetailsServiceCard(title: 'Break Pad', price: '420'),
              SizedBox(height: 12.h),
              DetailsServiceCard(title: 'Oil Changes', price: '420'),
              SizedBox(height: 12.h),
              DetailsServiceCard(title: 'Oil Changes', price: '420'),
              SizedBox(height: 12.h),
              DetailsServiceCard(title: 'Oil Changes', price: '420'),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsServiceCard extends StatelessWidget {
  final String title;
  final String price;

  const DetailsServiceCard({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Service Charge',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '\$420',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
