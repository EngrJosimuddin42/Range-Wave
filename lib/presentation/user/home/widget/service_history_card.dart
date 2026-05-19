import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:range_wave/model/service_request_model.dart';
import '../../../../core/utils/color/app_colors.dart';

class ServiceHistoryCard extends StatelessWidget {
  final ServiceRequestModel data;
  final VoidCallback? onTap;

  const ServiceHistoryCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        '${data.carBrand} ${data.carModel}',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        data.serviceDate.toString(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        width: 100.w,
        height: 25.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.primary,
        ),
        child: Center(
          child: Text(
            data.status,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.hintText,
            ),
          ),
        ),
      ),
    );
  }
}
