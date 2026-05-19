import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/custom_http.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/model/customer_car_list.dart';

class CarService {
  Future<ApiResponse<List<CarListModel>>> getCustomerCarList() async {
    try {
      final response = await CustomHttp.get(
        endpoint: 'customer/my-cars',
        needAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonList = response.data;
        final List<CarListModel> customerCarList = jsonList
            .map((json) => CarListModel.fromJson(json))
            .toList();
        return ApiResponse.success(customerCarList);
      } else {
        return ApiResponse.error(response.error ?? 'Password reset failed');
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error('Something went wrong 404');
    }
  }

  Future<ApiResponse<bool>> customerAddCar(
    String brandName,
    String modelName,
    String year,
    String licensePlate,
    String tagNumber,
    String imageId,
  ) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'customer/add-cars-data',
        needAuth: true,
        body: [
          {
            'brand': brandName,
            'model': modelName,
            'year': year,
            'license_plate': licensePlate,
            'tag_number': tagNumber,
            'car_image_id': imageId,
          },
        ],
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

  Future<ApiResponse<String>> addCarImage(File image, String token) async {
    try {
      final response = await CustomHttp.multipart(
        endpoint: 'customer/add-cars-image',
        method: CommonCustomMethods.POST,
        headers: {'Authorization': 'Bearer $token'},
        files: [await http.MultipartFile.fromPath('image', image.path)],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final imageId = response.data['image_data_id'].toString();
        await AppHelper.instance.setCarImageId(imageId);
        return ApiResponse.success(imageId);
      } else {
        return ApiResponse.error(response.error ?? 'Image upload failed');
      }
    } catch (e) {
      print('ADD CAR IMAGE ERROR: $e');
      return ApiResponse.error('Something went wrong 404');
    }
  }
}
