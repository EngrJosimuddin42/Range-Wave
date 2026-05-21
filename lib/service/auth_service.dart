import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/core/utils/custom_http.dart';

import '../../model/login_model.dart';

class AuthService {
  /// ------------------------------------ signup ---------------------------------------- ///
  Future<ApiResponse<bool>> signup(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'auth/signup',
        body: {
          'full_name': name,
          'email': email,
          'password': password,
          'role': role,
        },
        needAuth: false,
        showFloatingError: false,
      );

      if (response.statusCode == 201 ||
          response.statusCode == 200 ||
          response.statusCode == 203) {
        print('=== SIGNUP RESPONSE: ${response.data}');
        final String? userId =
            response.data['user_id'] ?? response.data['data']?['user_id'];
        if (userId != null) {
          await AppHelper.instance.setUserId(userId);
        }

        return ApiResponse.success(true);
      } else {
        print('❌ SIGNUP FAILED: status=${response.statusCode} error=${response.error}');
        return ApiResponse.error(response.error ?? 'Signup failed');
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error('Something went wrong 404');
    }
  }

  /// ------------------------- signup Email verification --------------------------------- ///
  Future<ApiResponse<LoginModel>> verifyEmailSign(
      String verificationCode,
      String userId,
      ) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'auth/verify-user',
        body: {
          'user_id': userId,
          'code': verificationCode,
        },
        needAuth: false,
        showFloatingError: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('=== VERIFY RESPONSE DEBUG ===');
        print(response.data);

        AppHelper.instance.setAccessToken(response.data['access_token']);
        AppHelper.instance.setRefToken(response.data['refresh_token']);

        // Don't overwrite if not present
        final String? respUserId =
            response.data['user_id'] ?? response.data['data']?['user_id'];
        if (respUserId != null) {
          AppHelper.instance.setUserId(respUserId);
        } else {
          print(
            'INFO: verify-email response did not contain user_id, keeping the one from signup.',
          );
        }

        AppHelper.instance.setAuthRole(response.data['role']);
        AppHelper.instance.setTokenValidity(
          response.data['access_token_valid_till'],
        );

        final loginModel = LoginModel.fromJson(response.data);
        return ApiResponse.success(loginModel);
      } else {
        // final json = jsonDecode(response.error!);
        final errorMessage = response.error;

        return ApiResponse.error(errorMessage!);
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error('Something went wrong 404');
    }
  }

  /// ------------------------- signIn   --------------------------------- ///
  Future<ApiResponse<LoginModel>> signIn(String email, String password) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'auth/login',
        body: {'user_email': email, 'password': password},
        needAuth: false,
        showFloatingError: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppHelper.instance.setAccessToken(response.data['access_token']);
        AppHelper.instance.setRefToken(response.data['refresh_token']);
        AppHelper.instance.setTokenValidity(
          response.data['access_token_valid_till'],
        );
        // Safer extraction for userId
        final String? userId =
            response.data['user_id'] ?? response.data['data']?['user_id'];
        if (userId != null) {
          AppHelper.instance.setUserId(userId);
        }

        AppHelper.instance.setAuthRole(response.data['role']);

        final loginModel = LoginModel.fromJson(response.data);
        return ApiResponse.success(loginModel);
      } else if (response.data != null && response.data['detail'] != null) {
        return ApiResponse.error(response.data['detail']);
      } else {
        return ApiResponse.error(response.error ?? 'Credentials mismatch');
      }
    } catch (e) {
      print('SIGN IN ERROR: $e');
      return ApiResponse.error('Something went wrong. Please try again.');
    }
  }

  /// ------------------ Refresh token ------------------------------- ///
  // Future<void> getRefAccessToken() async {
  //   try {
  //     final refToken = await AppHelper.instance.getRefToken();
  //     final response = await CustomHttp.post(
  //       endpoint: 'auth/refresh',
  //       needAuth: false,
  //       body: {'refresh_token': refToken},
  //     );
  //
  //     if (response.statusCode == 201 ||
  //         response.statusCode == 200 ||
  //         response.statusCode == 204) {
  //       await AppHelper.instance.setAccessToken('access_token');
  //     } else {
  //       print(response.statusCode);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     // return ApiResponse.error('Something went wrong 404');
  //   }
  // }

  /// ------------------------- forget password or reset password   --------------------------------- ///
  Future<ApiResponse<bool>> forgetPassEmailVerify(String email) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'auth/forgot-password',
        body: {'email': email},
        needAuth: false,
        showFloatingError: false,
      );

      if (response.statusCode == 201 ||
          response.statusCode == 200 ||
          response.statusCode == 204) {
        await AppHelper.instance.setUserId(response.data['user_id']);

        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(response.error ?? 'Request failed');
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error('Something went wrong 404');
    }
  }

  /// ------------------------- forget password Email OTP verification --------------------------------- ///
  Future<ApiResponse<bool>> resetPassOtpVerify(
    String userId,
    String verificationCode,
  ) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'auth/verify-password-reset',
        body: {'user_id': userId, 'code': verificationCode},
        needAuth: false,
        showFloatingError: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppHelper.instance.setSecretKey(response.data['token']);
        return ApiResponse(success: true, data: true);
      } else {
        return ApiResponse.error(response.error ?? 'OTP verification failed');
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error('Something went wrong 404');
    }
  }

  /// ------------------------- reset Password --------------------------------- ///
  Future<ApiResponse<bool>> resetPass(
    String userId,
    String newPassword,
    String token,
  ) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'auth/reset-password',
        body: {'user_id': userId, 'password': newPassword, 'token': token},
        needAuth: false,
        showFloatingError: false,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return ApiResponse(data: true, success: true);
      } else {
        return ApiResponse.error(response.error ?? 'Password reset failed');
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error('Something went wrong 404');
    }
  }

  /// ------------------------- resend OTP --------------------------------- ///
  Future<ApiResponse<bool>> resendOtp(String userId) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'auth/resend-code',
        body: {'user_id': userId},
        needAuth: false,
        showFloatingError: false,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return ApiResponse(data: true, success: true);
      } else {
        return ApiResponse.error(response.error ?? 'Failed to resend OTP');
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error('Something went wrong 404');
    }
  }
}
