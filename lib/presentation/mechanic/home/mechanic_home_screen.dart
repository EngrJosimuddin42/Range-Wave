import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/controller/service_request_controller.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import 'package:range_wave/model/service_request_model.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/service_hisory_model.dart';
import '../../user/home/widget/service_history_card.dart';

class MechanicHomeScreen extends StatefulWidget {
  const MechanicHomeScreen({super.key});

  @override
  State<MechanicHomeScreen> createState() => _MechanicHomeScreenState();
}

class _MechanicHomeScreenState extends State<MechanicHomeScreen> {
  bool isOnline = true;
  ServiceRequestController serviceRequestController = Get.put(
    ServiceRequestController(),
  );

  final List<ServiceHistoryModel> serviceHistoryList = [
    ServiceHistoryModel(
      name: 'Honda Civic',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: 'Repairing',
      priceTextColor: AppColors.textPrimary,
      priceContainerColor: AppColors.white,
    ),
    ServiceHistoryModel(
      name: 'Honda Civic',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: 'Start Service',
      priceTextColor: AppColors.textPrimary,
      priceContainerColor: AppColors.white,
    ),
    ServiceHistoryModel(
      name: 'Honda Civic',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: 'Inspecting',
      priceTextColor: AppColors.textPrimary,
      priceContainerColor: AppColors.white,
    ),
    ServiceHistoryModel(
      name: 'Honda Civic',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: 'Upcoming',
      priceTextColor: AppColors.primary,
      priceContainerColor: AppColors.orangeLight,
    ),
    ServiceHistoryModel(
      name: 'Honda Civic',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: '\$1250',
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Assets.images.appLogoTitle.image(),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.notification);
                    },
                    icon: Icon(Icons.notifications_active),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              /// STATUS CONTAINER
              _statusContainer(),

              SizedBox(height: 16.h),

              /// ANALYTICS SECTION
              _analyticsSection(),

              SizedBox(height: 20.h),

              /// TITLE
              AppTitle(
                title: 'Incoming Job Request',
                isShowAll: false,
                onTap: () {},
              ),

              SizedBox(height: 12.h),

              /// JOB REQUEST CARD
              Obx(() {
                if (serviceRequestController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (serviceRequestController.serviceRequests.isEmpty) {
                  return Center(
                    child: Text(
                      'No incoming job requests yet!',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                  );
                }
                return _jobRequestCard(
                  serviceRequestController.serviceRequests,
                );
              }),

              SizedBox(height: 20.h),

              AppTitle(title: 'Jobs List', isShowAll: true, onTap: () {}),

              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: serviceHistoryList.length,
              //   itemBuilder: (context, index) {
              //     return ServiceHistoryCard(data: serviceHistoryList[index]);
              //   },
              // ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= STATUS =================
  Widget _statusContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Status',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                ),
              ),
              SizedBox(width: 12.w),
              Switch(
                value: isOnline,
                onChanged: (value) {
                  setState(() {
                    isOnline = value;
                  });
                },
                activeTrackColor: AppColors.blue,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            isOnline
                ? 'You are online and available for jobs'
                : 'You are offline',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= ANALYTICS =================
  Widget _analyticsSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: AnalyticsCard(title: 'Today’s Earning', value: '\$1250'),
              ),
              SizedBox(width: 15),
              Expanded(
                child: AnalyticsCard(title: 'Active Jobs', value: '3'),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: AnalyticsCard(title: 'Completed', value: '12'),
              ),
              SizedBox(width: 15),
              Expanded(
                child: AnalyticsCard(title: 'Your Rating', value: '4.8'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= JOB CARD =================
  Widget _jobRequestCard(RxList<ServiceRequestModel> serviceRequests) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: serviceRequests.length,
        itemBuilder: (context, index) {
          return IncomingJobCard(serviceRequest: serviceRequests[index]);
        },
      ),
    );
  }
}

class IncomingJobCard extends StatelessWidget {
  final ServiceRequestModel serviceRequest;
  const IncomingJobCard({super.key, required this.serviceRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT SIDE (Avatar + Timer)
          Column(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundImage: serviceRequest.customerAvatar,
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: 60.w,
                child: LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: AppColors.blue.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(AppColors.blue),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '40 sec',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),

          SizedBox(width: 16.w),

          /// RIGHT SIDE (Job Info)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceRequest.issueSummary,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${serviceRequest.carBrand} ${serviceRequest.carModel}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                SizedBox(height: 8.h),

                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    ChipsButtonInfo(
                      title: 'Urgent',
                      colorBg: AppColors.red.withValues(alpha: 0.2),
                      textColor: AppColors.red.withValues(alpha: 0.6),
                    ),
                    ChipsButtonInfo(title: '12 miles'),
                    ChipsButtonInfo(title: 'E.A. \$1250'),
                  ],
                ),

                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'Decline',
                        backgroundColor: AppColors.surface,
                        textStyle: TextStyle(color: AppColors.textPrimary),
                        height: 33.h,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Accept',
                        backgroundColor: AppColors.primary,
                        height: 33.h,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= ANALYTICS CARD =================
class AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;

  const AnalyticsCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F2FF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

class ChipsButtonInfo extends StatelessWidget {
  final String title;
  final Color? colorBg;
  final Color? textColor;

  const ChipsButtonInfo({
    super.key,
    required this.title,
    this.colorBg,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorBg ?? Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: textColor ?? AppColors.textPrimary,
          fontFamily: GoogleFonts.manrope().fontFamily,
        ),
      ),
    );
  }
}
