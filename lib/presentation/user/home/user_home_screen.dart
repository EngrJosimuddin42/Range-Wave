import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:range_wave/controller/car_controller.dart';
import 'package:range_wave/controller/user_history_controller.dart';
import 'package:range_wave/core/utils/common_widget/added_car_card.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/presentation/user/home/widget/service_history_card.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../gen/assets.gen.dart';

class UserHomeScreen extends StatelessWidget {

  UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carController = Get.put(CarController());
    final userHistoryController = Get.put(UserHistoryController());

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopLogo(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Assets.images.bannerImg.image(
                        width: double.infinity,
                        height: 150.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    AppTitle(
                      title: 'My Car',
                      isShowAll: false,
                      onTap: () {
                        Get.toNamed(AppRoutes.carList);
                      },
                    ),
                    SizedBox(height: 16.h),

                    // ================= MY CAR API SECTION =================
                    Obx(() {
                      if (carController.isLoading2.value) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }
                      if (carController.carList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Text(
                              "No cars added yet.",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textTernary,
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        height: 160.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: carController.carList.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 16.w),
                          itemBuilder: (context, index) {
                            final car = carController.carList[index];
                            return AddedCarCard(
                              carName: car.brand,
                              carModel: car.model,
                              image: car.imageUrl,
                            );
                          },
                        ),
                      );
                    }),
                    SizedBox(height: 32.h),

                    AppTitle(
                      title: 'Service history List',
                      isShowAll: true,
                      onTap: () {
                        Get.toNamed(AppRoutes.userHistory);
                      },
                    ),

                    SizedBox(height: 20.h),

                    // ================= USER HISTORY API SECTION =================
                    Obx(() {
                      if (userHistoryController.isLoading.value) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        );
                      }

                      if (userHistoryController.serviceHistoryList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Text(
                              "No service history found.",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textTernary,
                              ),
                            ),
                          ),
                        );
                      }

                      //  Home screen এ শুধু প্রথম ৩টা দেখাবে
                      final displayList = userHistoryController.serviceHistoryList.take(3).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayList.length,
                        itemBuilder: (context, index) {
                          final historyData = displayList[index];
                          return ServiceHistoryCard(
                            onTap: () {
                              Get.toNamed(AppRoutes.serviceInProgress);
                            },
                            data: historyData,
                          );
                        },
                      );
                    }),


                    SizedBox(height: 50.h),

                    PrimaryButton(
                      text: 'Schedule a Service',
                      borderColor: AppColors.textSecondary.withValues( alpha: 0.2),
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500),
                      onTap: () {
                        Get.toNamed(AppRoutes.userScheduleService);
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}