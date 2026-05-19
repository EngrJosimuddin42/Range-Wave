import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/presentation/user/home/widget/service_history_card.dart';

import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/app_title.dart';
import '../../../core/utils/common_widget/app_top_section.dart';
import '../../../model/service_hisory_model.dart';

class SeeAllServiceHistoryScreen extends StatelessWidget {
  SeeAllServiceHistoryScreen({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopLogo(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back_ios_new_outlined),
                      ),
                      Expanded(
                        child: AppTitle(
                          title: 'Service history List',
                          isShowAll: false,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // ListView.builder(
                  //   padding: EdgeInsets.zero,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
