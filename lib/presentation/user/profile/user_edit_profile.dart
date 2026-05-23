import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:range_wave/controller/customer_profile_controller.dart';
import 'package:range_wave/core/utils/common_widget/custom_text_field.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';
import '../../../core/utils/color/app_colors.dart';

class UserEditProfile extends StatefulWidget {
  const UserEditProfile({super.key});

  @override
  State<UserEditProfile> createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {
  late final CustomerProfileController profileController;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController addressController  = TextEditingController();

  String _phoneNumber      = '';
  String _initialPhone     = '';
  String _initialCountry   = 'BD';

  @override
  void initState() {
    super.initState();
    profileController = Get.isRegistered<CustomerProfileController>()
        ? Get.find<CustomerProfileController>()
        : Get.put(CustomerProfileController());

    final data = profileController.customerData;
    fullNameController.text = data['full_name'] ?? '';
    emailController.text    = data['email']     ?? '';
    addressController.text  = data['address']   ?? '';

    //  Phone parse — country code আলাদা করো
    final rawPhone = data['phone']?.toString() ?? '';
    _phoneNumber = rawPhone;

    if (rawPhone.startsWith('+880')) {
      _initialCountry = 'BD';
      _initialPhone   = rawPhone.replaceFirst('+880', '');
    } else if (rawPhone.startsWith('+1')) {
      _initialCountry = 'US';
      _initialPhone   = rawPhone.replaceFirst('+1', '');
    } else if (rawPhone.startsWith('+91')) {
      _initialCountry = 'IN';
      _initialPhone   = rawPhone.replaceFirst('+91', '');
    } else if (rawPhone.startsWith('+')) {
      // অন্য country — number রাখো, code বাদ দাও
      _initialPhone = rawPhone.replaceAll(RegExp(r'^\+\d{1,3}'), '');
    } else {
      _initialPhone = rawPhone;
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // ── Avatar picker
              Center(
                child: Obx(() {
                  final localFile  = profileController.selectedAvatar.value;
                  final networkUrl = profileController.profileImageUrl.value;

                  return GestureDetector(
                    onTap: profileController.pickAvatar,
                    child: Stack(
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            image: localFile != null
                                ? DecorationImage(
                              image: FileImage(localFile),
                              fit: BoxFit.cover,
                            )
                                : networkUrl.isNotEmpty
                                ? DecorationImage(
                              image: NetworkImage(networkUrl),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: (localFile == null && networkUrl.isEmpty)
                              ? Icon(Icons.person, size: 40.w, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 16.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              SizedBox(height: 20.h),

              // ── Full name
              CustomTextField(
                controller: fullNameController,
                hintText: 'Enter your full name',
              ),
              SizedBox(height: 8.h),

              // ── Email — read only
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                readOnly: true,
                filColor: AppColors.buttonTextColor.withValues(alpha: 0.5),
                filled: true,
                suffixIcon: Icon(
                  Icons.lock_outline,
                  size: 18.w,
                  color: AppColors.textPrimary.withValues(alpha: 0.4),
                ),
              ),
              SizedBox(height: 8.h),

              // ── Phone — IntlPhoneField
              IntlPhoneField(
                keyboardType: TextInputType.number,
                initialCountryCode: _initialCountry,
                initialValue: _initialPhone,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.textPrimary.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.textPrimary.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.textPrimary.withValues(alpha: 0.2),
                      width: 1.5.w,
                    ),
                  ),
                ),
                onChanged: (phone) {
                  _phoneNumber = phone.completeNumber;
                },
              ),
              SizedBox(height: 8.h),

              // ── Address
              CustomTextField(
                controller: addressController,
                hintText: 'Address'),
              SizedBox(height: 50.h),

              // ── Save button
              Obx(() => PrimaryButton(
                loading: profileController.isUpdating.value,
                text: 'Save Changes',
                backgroundColor: AppColors.primary,
                onTap: () async {
                  final success = await profileController.updateProfile(
                    fullName: fullNameController.text.trim(),
                    phone:    _phoneNumber,
                    address:  addressController.text.trim(),
                  );
                  if (success) Get.back();
                },
              )),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}