import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:range_wave/controller/signup_controller.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/service/profile_service.dart';

import '../core/app_credentials.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  final ImagePicker _picker = ImagePicker();

  // Change password
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Mechanic profile
  TextEditingController fullNameController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController initialChargeController = TextEditingController();
  TextEditingController yearOfExperienceController = TextEditingController();
  TextEditingController serviceAreaController = TextEditingController();
  TextEditingController specialityInputController = TextEditingController();

  RxBool isLoading = RxBool(false);
  RxList<String> specialistList = RxList<String>([]);
  Rx<File?> profileImage = Rx<File?>(null);
  Rx<File?> nationalIdImage = Rx<File?>(null);
  RxList<File> certificateImages = RxList<File>([]);
  RxBool isFromSignup = RxBool(false);

  RxMap<String, dynamic> meData = RxMap({});
  RxMap<String, dynamic> mechanicData = RxMap({});
  RxString profileImageUrl = RxString('');
  RxString nationalIdImageUrl = RxString('');
  RxList<String> certificateImageUrls = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
  }



  Future<void> loadProfile({bool forceReload = false}) async {
    if (!forceReload && mechanicData.isNotEmpty) return;

    isLoading.value = true;

    final mechResp = await _profileService.getMechanicProfile();
    print('===== GET MECHANIC =====');
    print('Data: ${mechResp.data}');

    if (mechResp.success && mechResp.data != null) {
      final data = mechResp.data!;

      mechanicData.assignAll(data);
      mechanicData.refresh();

      fullNameController.text = data['full_name'] ?? '';
      shopNameController.text = data['shop_name'] ?? '';
      final charge = double.tryParse(data['initial_charge']?.toString() ?? '');
      initialChargeController.text = charge != null ? charge.toInt().toString() : '';
      yearOfExperienceController.text = data['year_of_experience']?.toString() ?? '';
      serviceAreaController.text = data['service_area'] ?? '';

      final rawUrl = data['avatar_url'] ?? '';
      print('RAW AVATAR URL: $rawUrl');
      if (rawUrl.isNotEmpty) {
        profileImageUrl.value = AppCredentials.resolveUrl(rawUrl);
      }


//  national id image url
      final nationalIdUrl = data['national_id_image_url'] ?? '';
      if (nationalIdUrl.isNotEmpty) {
        nationalIdImageUrl.value = AppCredentials.resolveUrl(nationalIdUrl);
      }

// certificate image urls
      final certs = data['certificates'];
      if (certs != null && certs is List) {
        certificateImageUrls.assignAll(
          certs.map((c) {
            final url = c['certificate_image_url']?.toString() ?? '';
            return AppCredentials.resolveUrl(url);
          }).where((url) => url.isNotEmpty).toList(),
        );
      }

      final specs = data['specialist'];
      if (specs != null && specs is List) {
        specialistList.assignAll(specs.map((e) => e.toString()).toList());
      }
    }

    isLoading.value = false;
  }



  Future<void> saveMechanicProfile() async {
    if (isLoading.value) return;
    isLoading.value = true;

    if (isFromSignup.value && fullNameController.text.trim().isEmpty) {
      if (Get.isRegistered<SignupController>()) {
        final signupController = Get.find<SignupController>();
        fullNameController.text = signupController.nameController.text.trim();
        debugPrint('====== SIGNUP NAME COPIED: ${fullNameController.text} ======');
      }
    }

    String? mechanicImageId;

    // Step 1: Image upload
    if (profileImage.value != null ||
        nationalIdImage.value != null ||
        certificateImages.isNotEmpty) {
      final imageResp = await _profileService.saveMechanicImages(
        profileImage: profileImage.value,
        nationalIdImage: nationalIdImage.value,
        certificateImages: certificateImages,
      );

      if (imageResp.success && imageResp.data != null) {
        final responseData = imageResp.data as Map<String, dynamic>;
        mechanicImageId = responseData['mechanic_image_data_id'];
      } else {
        isLoading.value = false;
        showCustomToast(
          text: imageResp.error ?? 'Image upload failed',
          toastType: ToastTypesInfo(ToastTypes.error),
        );
        return;
      }
    }

    // Step 2: Save data
    final dataResp = await _profileService.saveMechanicData(
      fullName: fullNameController.text.trim(),
      shopName: shopNameController.text.trim(),
      initialCharge: initialChargeController.text.trim(),
      yearOfExperience: int.tryParse(yearOfExperienceController.text.trim()) ?? 0,
      serviceArea: serviceAreaController.text.trim(),
      specialist: specialistList.toList(),
      mechanicImageId: mechanicImageId,
    );

    isLoading.value = false;

    if (dataResp.success) {
      showCustomToast(
        text: 'Profile saved successfully!',
        toastType: ToastTypesInfo(ToastTypes.success),
      );

      if (isFromSignup.value) {
        Get.offAllNamed(AppRoutes.mechanicBottomNav);
        loadProfile(forceReload: true);
      } else {
        Get.back();
        loadProfile(forceReload: true);
      }
    } else {
      showCustomToast(
        text: dataResp.error ?? 'Something went wrong',
        toastType: ToastTypesInfo(ToastTypes.error),
      );
    }
  }


  void addSpecialist(String value) {
    if (value.trim().isNotEmpty && !specialistList.contains(value.trim())) {
      specialistList.add(value.trim());
      specialityInputController.clear();
    }
  }

  void removeSpecialist(String value) {
    specialistList.remove(value);
  }

  Future<void> pickProfileImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) profileImage.value = File(file.path);
  }

  Future<void> pickNationalIdImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) nationalIdImage.value = File(file.path);
  }

  Future<void> pickCertificateImages() async {
    final files = await _picker.pickMultiImage();
    if (files.isNotEmpty) {
      certificateImages.addAll(files.map((f) => File(f.path)));
    }
  }



  Future<bool> changePassword() async {
    isLoading.value = true;

    final response = await _profileService.changePassword(
      oldPassword: oldPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
    );

    isLoading.value = false;

    if (response.success && response.data != null) {
      showCustomToast(
        text: 'Password updated successfully',
        toastType: ToastTypesInfo(ToastTypes.success),
      );
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      return true;
    } else {
      showCustomToast(
        text: response.error ?? 'Something went wrong',
        toastType: ToastTypesInfo(ToastTypes.error),
      );
      return false;
    }
  }
}