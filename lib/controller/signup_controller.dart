import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/service/auth_service.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(
    text: 'abid',
  );
  final TextEditingController emailController = TextEditingController(
    text: "a@gmail.com",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "123456",
  );
  final TextEditingController confirmPasswordController = TextEditingController(
    text: "123456",
  );

  RxBool isLoading = RxBool(false);
  RxString selectedRole = RxString('');
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final AuthService _authService = AuthService();

  Future<void> getImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      selectedImage.value = file;
    } else {}
  }

  RxBool isAgreed = false.obs;

  final TextEditingController yearController = TextEditingController();

  Future<bool> signup() async {
    isLoading.value = true;
    final response = await _authService.signup(
      nameController.text,
      emailController.text,
      passwordController.text,
      selectedRole.value,
    );

    if (response.data != null) {
      isLoading.value = false;
      return true;
    } else {
      isLoading.value = false;
      showCustomToast(
        text: response.error ?? 'something went wrong',
        toastType: ToastTypesInfo(ToastTypes.error),
      );
      return false;
    }
  }
}
