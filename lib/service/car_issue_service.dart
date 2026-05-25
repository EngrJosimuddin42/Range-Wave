import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/custom_http.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/model/car_issue_model.dart';

class CarIssueService {

  Future<ApiResponse<CarIssueModel>> submitCarIssue({
    required String carId,
    required String description,
    required String serviceDate,
    required String serviceTime,
    required double latitude,
    required double longitude,
    File? imageFile,
    File? audioFile,
  }) async {
    try {
      final token = await AppHelper.instance.getAccessToken();
      if (token == null) return ApiResponse.error('No token found');

      // ── multipart files list ──────────────────────────────────
      final List<http.MultipartFile> files = [];

      if (imageFile != null) {
        files.add(
          await http.MultipartFile.fromPath('images', imageFile.path),
        );
      }

      if (audioFile != null) {
        files.add(
          await http.MultipartFile.fromPath('audio', audioFile.path),
        );
      }

      // ── fields (text) ────────────────────────────────────────
      final Map<String, String> fields = {
        'description'  : description,
        'service_date' : serviceDate,
        'service_time' : serviceTime,
        'latitude'     : latitude.toString(),
        'longitude'    : longitude.toString(),
      };

      final response = await CustomHttp.multipart(
        endpoint : 'customer/car-issue/$carId',
        method   : CommonCustomMethods.POST,
        headers  : {'Authorization': 'Bearer $token'},
        files    : files,
        fields   : fields,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = CarIssueModel.fromJson(response.data);
        return ApiResponse.success(model);
      } else {
        return ApiResponse.error(response.error ?? 'Submission failed');
      }
    } catch (e) {
      print('SUBMIT CAR ISSUE ERROR: $e');
      return ApiResponse.error('Something went wrong');
    }
  }
}