import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/app_top_section.dart';
import '../../../gen/assets.gen.dart';

class RecommendedMatchesScreen extends StatelessWidget {
  RecommendedMatchesScreen({super.key});

  final List<RecommendedMatchModel> matchList = [
    RecommendedMatchModel(
      name: 'Alica Jacobe',
      imageUrl:
          'https://images.pexels.com/photos/6170742/pexels-photo-6170742.jpeg',
      time: '5 min',
      originalPrice: 560,
      offerPrice: 550,
      rating: 4.5,
      bgColor: AppColors.blue.withValues(alpha: 0.1),
    ),
    RecommendedMatchModel(
      name: 'John Carter',
      imageUrl:
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg',
      time: '8 min',
      originalPrice: 600,
      offerPrice: 575,
      rating: 4.7,
      bgColor: AppColors.surface,
    ),
    RecommendedMatchModel(
      name: 'Emma Watson',
      imageUrl:
          'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
      time: '3 min',
      originalPrice: 500,
      offerPrice: 480,
      rating: 4.8,
      bgColor: AppColors.surface,
    ),
    RecommendedMatchModel(
      name: 'Michael Brown',
      imageUrl:
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
      time: '12 min',
      originalPrice: 650,
      offerPrice: 620,
      rating: 4.3,
      bgColor: AppColors.surface,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopLogo(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Recommended Matches',
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

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: matchList.length,
                itemBuilder: (context, index) {
                  final match = matchList[index];
                  return _matchTile(match, () {
                    Get.toNamed(AppRoutes.mechanicPortfolio);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _matchTile(RecommendedMatchModel match, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: match.bgColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
          leading: CircleAvatar(
            radius: 28.r,
            backgroundImage: NetworkImage(match.imageUrl),
          ),
          title: Text(
            match.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                match.time,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '\$${match.originalPrice}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          trailing: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${match.offerPrice}',
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
                      match.rating.toString(),
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

class RecommendedMatchModel {
  final String name;
  final String imageUrl;
  final String time;
  final double originalPrice;
  final double offerPrice;
  final double rating;
  final Color bgColor;

  RecommendedMatchModel({
    required this.name,
    required this.imageUrl,
    required this.time,
    required this.originalPrice,
    required this.offerPrice,
    required this.rating,
    required this.bgColor,
  });
}
