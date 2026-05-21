import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/service/auth_service.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxString selectedRole = RxString('');
  RxBool isLoading = RxBool(false);
  final AuthService _authService = AuthService();

  Future<String?> signin() async {
    isLoading.value = true;
    final response = await _authService.signIn(
      emailController.text,
      passwordController.text,
    );

    if (response.data != null) {
      isLoading.value = false;
      print(response.data!.role);
      return response.data!.role;
    } else {
      isLoading.value = false;
      showCustomToast(
        text: response.error ?? 'something went wrong',
        toastType: ToastTypesInfo(ToastTypes.error),
      );
      return null;
    }
  }
}
