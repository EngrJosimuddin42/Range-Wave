import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/presentation/user/home/widget/service_history_card.dart';
import 'package:range_wave/controller/user_history_controller.dart';

import '../../../core/utils/color/app_colors.dart';
import '../../../core/utils/common_widget/app_title.dart';
import '../../../core/utils/common_widget/app_top_section.dart';

class SeeAllServiceHistoryScreen extends StatelessWidget {
  SeeAllServiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userHistoryController = Get.find<UserHistoryController>();

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
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
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
                ],
              ),
            ),


            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(() {
                  if (userHistoryController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (userHistoryController.serviceHistoryList.isEmpty) {
                    return Center(
                      child: Text(
                        "No service history found.",
                        style: TextStyle(fontSize: 14.sp, color: AppColors.textTernary),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 20.h),
                    itemCount: userHistoryController.serviceHistoryList.length,
                    itemBuilder: (context, index) {
                      final historyData = userHistoryController.serviceHistoryList[index];
                      return ServiceHistoryCard(
                        onTap: () {
                          Get.toNamed(AppRoutes.serviceInProgress);
                        },
                        data: historyData,
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}