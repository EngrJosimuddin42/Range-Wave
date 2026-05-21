import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/service/auth_service.dart';

class ForgotPassController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isLoading = false.obs;
  final AuthService _authService = AuthService();

  // Timer
  final RxInt remainingSeconds = 60.obs;
  final RxBool canResend = false.obs;
  String otp = '';
  Timer? _timer;

  void startTimer() {
    remainingSeconds.value = 60;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  String get formattedTime {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:${seconds}s';
  }

  Future<void> resendOtp() async {
    final success = await verifyEmail();
    if (success) {
      startTimer();
      showCustomToast(text: "OTP resent successfully");
    }
  }

  Future<bool> verifyEmail() async {
    isLoading.value = true;
    final response = await _authService.forgetPassEmailVerify(
      emailController.text.trim(),
    );

    if (response.data == true) {
      isLoading.value = false;
      return true;
    } else {
      isLoading.value = false;
      showCustomToast(
        text: response.error ?? "something went wrong. Please try again",
      );
      return false;
    }
  }

  Future<bool> verifyOtp() async {
    isLoading.value = true;
    final userId = await AppHelper.instance.getUserId();
    if (userId == null) return false;
    final response = await _authService.resetPassOtpVerify(userId, otp);

    if (response.data == true) {
      isLoading.value = false;
      return true;
    } else {
      isLoading.value = false;
      showCustomToast(
        text: response.error ?? "something went wrong. Please try again",
      );
      return false;
    }
  }

  Future<void> resendCode() async {
    final userId = await AppHelper.instance.getUserId();
    if (userId == null) return;

    final response = await _authService.resendOtp(userId);
    if (response.data == true) {
      startTimer();
      showCustomToast(
        text: "OTP resent successfully",
        toastType: ToastTypesInfo(ToastTypes.success),
      );
    } else {
      showCustomToast(
        text: response.error ?? "something went wrong. Please try again",
        toastType: ToastTypesInfo(ToastTypes.error),
      );
    }
  }

  Future<bool> resetPassword() async {
    isLoading.value = true;
    final secretKey = await AppHelper.instance.getSecretKey();
    if (secretKey == null) return false;
    final userId = await AppHelper.instance.getUserId();
    if (userId == null) return false;

    final response = await _authService.resetPass(
      userId,
      confirmPasswordController.text.trim(),
      secretKey,
    );
    if (response.data == true) {
      isLoading.value = false;
      return true;
    } else {
      isLoading.value = false;
      showCustomToast(
        text: response.error ?? "something went wrong. Please try again",
      );
      return false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
