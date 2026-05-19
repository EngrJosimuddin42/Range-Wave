import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/controller/service_request_controller.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';

import '../../../core/navigation/app_routes.dart';
import '../../user/home/widget/service_history_card.dart';
import '../../../controller/mechanic_history_controller.dart';

class MechanicHistoryScreen extends StatelessWidget {
  MechanicHistoryScreen({super.key});

  final MechanicHistoryController controller = Get.put(
    MechanicHistoryController(),
  );

  final ServiceRequestController serviceRequestController = Get.put(
    ServiceRequestController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.surface,
        title: Text(
          'History',
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: GoogleFonts.manrope().fontFamily,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '12 January 2025',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.chips.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          final isSelected =
                              controller.selectedChipIndex.value == index;

                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: () => controller.selectedChipIndex(index),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.3)
                                      : AppColors.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                      color: AppColors.textPrimary.withValues(
                                        alpha: 0.15,
                                      ),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.color,
                                    fontSize: 16.sp,
                                    fontFamily:
                                        GoogleFonts.manrope().fontFamily,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: serviceRequestController.serviceRequests.length,
                    itemBuilder: (context, index) {
                      return ServiceHistoryCard(
                        onTap: () {
                          Get.toNamed(AppRoutes.mechanicHistoryDetails);
                        },
                        data: serviceRequestController.serviceRequests[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
