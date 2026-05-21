import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/core/utils/custom_http.dart';

class ProfileService {


  Future<ApiResponse<bool>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'auth/update-password',
        needAuth: true,
        body: {
          'new_password': newPassword,
          'old_password': oldPassword,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(response.error ?? 'Password reset failed');
      }
    } catch (e) {
      return ApiResponse.error('Something went wrong 404');
    }
  }



  Future<ApiResponse<bool>> saveMechanicData({
    required String fullName,
    required String shopName,
    required String initialCharge,
    required int yearOfExperience,
    required String serviceArea,
    required List<String> specialist,
    String? mechanicImageId,
  }) async {
    try {
      final Map<String, dynamic> bodyData = {
        'full_name': fullName,
        'shop_name': shopName,
        'initial_charge': double.tryParse(initialCharge)?.toInt() ?? 0,
        'year_of_experience': yearOfExperience,
        'service_area': serviceArea,
        'specialist': specialist,
      };

      if (mechanicImageId != null && mechanicImageId.isNotEmpty) {
        bodyData['mechanic_image_data_id'] = mechanicImageId;
      }

      print('<===== MECHANIC DATA POST REQUEST =====>');
      print('URL: mechanic/save-mechanic-data');
      print('BODY DATA: $bodyData');

      final response = await CustomHttp.post(
        endpoint: 'mechanic/save-mechanic-data',
        needAuth: true,
        body: bodyData,
      );

      print('<===== BACKEND RESPONSE =====>');
      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE DATA: ${response.data}');
      print('RESPONSE ERROR: ${response.error}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(response.error ?? 'Server rejected data (${response.statusCode})');
      }
    } catch (e) {
      print('MECHANIC DATA EXCEPTION: $e');
      return ApiResponse.error('Something went wrong 404');
    }
  }



  Future<ApiResponse<dynamic>> saveMechanicImages({
    File? profileImage,
    File? nationalIdImage,
    List<File> certificateImages = const [],
  }) async {
    try {
      final token = await AppHelper.instance.getAccessToken();
      final List<http.MultipartFile> files = [];

      if (profileImage != null) {
        files.add(await http.MultipartFile.fromPath('profile_image', profileImage.path));
      }
      if (nationalIdImage != null) {
        files.add(await http.MultipartFile.fromPath('national_id_image', nationalIdImage.path));
      }
      for (final cert in certificateImages) {
        files.add(await http.MultipartFile.fromPath('certificate_images[]', cert.path));
      }
      if (files.isEmpty) return ApiResponse.success(true);

      final response = await CustomHttp.multipart(
        endpoint: 'mechanic/save-mechanic-image-data',
        method: CommonCustomMethods.POST,
        headers: {'Authorization': 'Bearer $token'},
        files: files,
      );

      print('IMAGE UPLOAD STATUS: ${response.statusCode}');
      print('IMAGE UPLOAD RESPONSE: ${response.data}');
      print('IMAGE UPLOAD ERROR: ${response.error}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error(response.error ?? 'Failed to upload images');
      }
    } catch (e) {
      print('IMAGE UPLOAD EXCEPTION: $e');
      return ApiResponse.error('Something went wrong 404');
    }
  }


  Future<ApiResponse<Map<String, dynamic>>> getMechanicProfile() async {
    try {
      final response = await CustomHttp.get(
        endpoint: 'mechanic/my-data',
        needAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error(response.error ?? 'Failed to get mechanic profile');
      }
    } catch (e) {
      return ApiResponse.error('Something went wrong');
    }
  }
}