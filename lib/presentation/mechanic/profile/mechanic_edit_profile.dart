import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:range_wave/controller/profile_controller.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import '../../../core/utils/color/app_colors.dart';
import '../../../gen/assets.gen.dart';

class MechanicEditProfile extends StatefulWidget {
  const MechanicEditProfile({super.key});

  @override
  State<MechanicEditProfile> createState() => _MechanicEditProfileState();
}


class _MechanicEditProfileState extends State<MechanicEditProfile> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    final args = Get.arguments;
    final isFromSignup = args != null && args['fromSignup'] == true;
    controller.isFromSignup.value = isFromSignup;

    if (!isFromSignup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadProfile();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isFromSignup.value ? 'Profile Setup' : 'Edit Profile',
        )),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Profile Image
              Center(
                child: Obx(() => GestureDetector(
                  onTap: controller.pickProfileImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55.r,
                        backgroundImage: controller.profileImage.value != null
                            ? FileImage(controller.profileImage.value!)
                            : (controller.profileImageUrl.isNotEmpty
                            ? NetworkImage(
                            controller.profileImageUrl.value)
                        as ImageProvider
                            : null),
                        child: controller.profileImage.value == null &&
                            controller.profileImageUrl.isEmpty
                            ? Icon(Icons.person,
                            size: 55.r, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Assets.icons.profile_edit.svg(
                          width: 24.w,
                          height: 24.w,
                          colorFilter: ColorFilter.mode(
                              AppColors.primary, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                )),
              ),

              SizedBox(height: 20.h),

              Obx(() {
                if (controller.isFromSignup.value) {
                  return const SizedBox.shrink();
                } else {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: CustomTextField(
                      controller: controller.fullNameController,
                      hintText: 'Full Name',
                    ),
                  );
                }
              }),

              SizedBox(height: 8.h),
              CustomTextField(
                controller: controller.shopNameController,
                hintText: 'Enter shop name',
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: controller.initialChargeController,
                hintText: 'Enter initial service charge',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: controller.yearOfExperienceController,
                hintText: 'Year of experience',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: controller.serviceAreaController,
                hintText: 'Service area',
              ),
              SizedBox(height: 16.h),

              // Specialist section
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.textPrimary.withValues(alpha: 0.2)),
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Specialist',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(() => Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: controller.specialistList
                          .map((s) => _SpecialistChip(
                        label: s,
                        onRemove: () =>
                            controller.removeSpecialist(s),
                      ))
                          .toList(),
                    )),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: controller.specialityInputController,
                      hintText: 'Add specialty....',
                      filColor: AppColors.buttonTextColor,
                      filled: true,
                      suffixIcon: GestureDetector(
                        onTap: () => controller.addSpecialist(
                          controller.specialityInputController.text,
                        ),
                        child: Icon(Icons.add, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // National ID
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.textPrimary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Id Prof',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      if (controller.nationalIdImage.value != null) {
                        return Row(
                          children: [
                            Icon(Icons.file_present, color: AppColors.blue, size: 18.w),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                controller.nationalIdImage.value!.path.split('/').last,
                                style: TextStyle(color: AppColors.blue, fontSize: 14.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.nationalIdImage.value = null,
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withValues(alpha: 0.2),
                                ),
                                child: Icon(Icons.close, size: 16.w, color: Colors.grey),
                              ),
                            ),
                          ],
                        );
                      }

                      // ✅ Server থেকে আসা URL থাকলে
                      if (controller.nationalIdImageUrl.value.isNotEmpty) {
                        return Row(
                          children: [
                            Icon(Icons.file_present, color: AppColors.blue, size: 18.w),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                'ID uploaded ✓',
                                style: TextStyle(color: AppColors.blue, fontSize: 14.sp),
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.pickNationalIdImage,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text('Change',
                                    style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary)),
                              ),
                            ),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('No file chosen',
                                    style: TextStyle(color: AppColors.blue, fontSize: 14.sp)),
                                Text('National ID/Driving License',
                                    style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.pickNationalIdImage,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text('Upload',
                                  style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary)),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Mechanical Certification
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.textPrimary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mechanical Certification',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      final serverUrls = controller.certificateImageUrls;
                      final newFiles = controller.certificateImages;

                      if (serverUrls.isEmpty && newFiles.isEmpty) {
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('No file chosen',
                                      style: TextStyle(color: AppColors.blue, fontSize: 14.sp)),
                                  Text('PDF, JPG, PNG',
                                      style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.pickCertificateImages,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text('Upload',
                                    style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary)),
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          ...serverUrls.asMap().entries.map((e) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              children: [
                                Icon(Icons.file_present, color: AppColors.blue, size: 18.w),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    'Certificate ${e.key + 1} ✓',
                                    style: TextStyle(color: AppColors.blue, fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          )),

                          ...newFiles.asMap().entries.map((e) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              children: [
                                Icon(Icons.file_present, color: AppColors.blue, size: 18.w),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    e.value.path.split('/').last,
                                    style: TextStyle(color: AppColors.blue, fontSize: 14.sp),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => controller.certificateImages.removeAt(e.key),
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withValues(alpha: 0.2),
                                    ),
                                    child: Icon(Icons.close, size: 16.w, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          )),

                          GestureDetector(
                            onTap: controller.pickCertificateImages,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text('Add more',
                                  style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary)),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              Obx(() => PrimaryButton(
                text: 'Save & Continue',
                loading: controller.isLoading.value,
                backgroundColor: AppColors.primary,
                onTap: controller.saveMechanicProfile,
              )),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

// _SpecialistChip
class _SpecialistChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _SpecialistChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.blueish,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.blue,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14.w, color: AppColors.blue),
          ),
        ],
      ),
    );
  }
}