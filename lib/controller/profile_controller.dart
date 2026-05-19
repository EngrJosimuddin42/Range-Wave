import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/service/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool isLoading = RxBool(false);

  Future<bool> changePassword() async {
    isLoading.value = true;
    final response = await _profileService.changePassword(
      newPasswordController.text.trim(),
      oldPasswordController.text.trim(),
    );
    if (response.data != null) {
      isLoading.value = false;
      return true;
    } else {
      isLoading.value = false;
      showCustomToast(
        text: response.error ?? 'Something went wrong, Please try again...',
        toastType: ToastTypesInfo(ToastTypes.error),
      );
      return false;
    }
  }
}
