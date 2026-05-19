import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:range_wave/controller/car_controller.dart';
import 'package:range_wave/core/utils/common_widget/added_car_card.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'package:range_wave/core/utils/common_widget/app_top_section.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/model/service_hisory_model.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../gen/assets.gen.dart';

class UserHomeScreen extends StatelessWidget {
  UserHomeScreen({super.key});

  final List<ServiceHistoryModel> serviceHistoryList = [
    ServiceHistoryModel(
      name: 'Mr. Alex',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: '\$1250',
      priceTextColor: AppColors.blue,
      priceContainerColor: AppColors.blueLight,
    ),
    ServiceHistoryModel(
      name: 'Mr. Alex',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: '\$1250',
      priceTextColor: AppColors.blue,
      priceContainerColor: AppColors.blueLight,
    ),
    ServiceHistoryModel(
      name: 'Mr. Alex',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: 'Upcoming',
      priceTextColor: AppColors.primary,
      priceContainerColor: AppColors.orangeLight,
    ),
    ServiceHistoryModel(
      name: 'Mr. Alex',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: 'Running',
      priceTextColor: AppColors.green,
      priceContainerColor: AppColors.greenLight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                      isShowAll: true,
                      onTap: () {
                        Get.toNamed(AppRoutes.carList);
                      },
                    ),
                    SizedBox(height: 16.h),
                    Obx(() {
                      final controller = Get.find<CarController>();
                      if (controller.isLoading2.value) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }
                      if (controller.carList.isEmpty) {
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
                          itemCount: controller.carList.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 16.w),
                          itemBuilder: (context, index) {
                            final car = controller.carList[index];
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
                        Get.toNamed(AppRoutes.seeAllServiceHistory);
                      },
                    ),

                    SizedBox(height: 20.h),

                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: serviceHistoryList.length,
                    //   itemBuilder: (context, index) {
                    //     return ServiceHistoryCard(
                    //       onTap: () {
                    //         Get.toNamed(AppRoutes.serviceInProgress);
                    //       },
                    //       data: serviceHistoryList[index],
                    //     );
                    //   },
                    // ),
                    SizedBox(height: 50.h),

                    PrimaryButton(
                      text: 'Schedule a Service',
                      borderColor: AppColors.textSecondary.withValues(
                        alpha: 0.2,
                      ),
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
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
