import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/custom_http.dart';

class ProfileService {
  Future<ApiResponse<bool>> changePassword(
    String newPassword,
    String oldPassword,
  ) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'auth/update-password',
        needAuth: true,
        body: {'new_password': newPassword, 'old_password': oldPassword},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(response.error ?? 'Password reset failed');
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error('Something went wrong 404');
    }
  }
}
