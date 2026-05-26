import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import '../../../core/navigation/app_routes.dart';
import '../../user/home/widget/service_history_card.dart';
import '../../../controller/mechanic_history_controller.dart';

class MechanicHistoryScreen extends StatelessWidget {
  const MechanicHistoryScreen({super.key}); // const করা হলো

  @override
  Widget build(BuildContext context) {

    final MechanicHistoryController controller = Get.find<MechanicHistoryController>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'History',
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: GoogleFonts.manrope().fontFamily,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // ── Chip Filter Card ──
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.white,
              ),
              child: Obx(
                    () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.chips.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = controller.selectedChipIndex.value == index;

                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: GestureDetector(
                          onTap: () {
                            debugPrint("🖱️ Clicked on Chip: $item (Index: $index)");
                            controller.selectedChipIndex(index);
                          },
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
                                  offset: const Offset(0, 2),
                                  color: AppColors.textPrimary.withValues(alpha: 0.15),
                                ),
                              ],
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                                fontSize: 16.sp,
                                fontFamily: GoogleFonts.manrope().fontFamily,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // ── History List ──
            Expanded(
              child: Obx(() {
                // Loading State
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Empty State
                if (controller.mechanicHistoryList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_outlined,
                          size: 64.sp,
                          color: AppColors.textSecondary.withValues(alpha: 0.4),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No history found',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.textSecondary,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Data List
                return RefreshIndicator(
                  onRefresh: controller.fetchMechanicHistory,
                  child: ListView.builder(
                    itemCount: controller.mechanicHistoryList.length,
                    itemBuilder: (context, index) {
                      return ServiceHistoryCard(
                        onTap: () {
                          Get.toNamed(AppRoutes.mechanicHistoryDetails);
                        },
                        data: controller.mechanicHistoryList[index],
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}