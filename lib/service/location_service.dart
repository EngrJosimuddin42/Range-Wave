import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/custom_http.dart';
import 'package:range_wave/model/location_model.dart';

class LocationService {
  Future<ApiResponse<LocationModel>> currentLocation(
    double latitude,
    double longitude,
    String userId,
  ) async {
    try {
      print(longitude);
      print(latitude);
      print(userId);

      final response = await CustomHttp.post(
        needAuth: false,
        endpoint: 'common/locations',
        body: {'latitude': latitude, 'longitude': longitude, 'user_id': userId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(LocationModel.fromJson(response.data));
      } else {
        return ApiResponse.error(response.error ?? 'Failed to update location');
      }
    } catch (e) {
      print('Location Service Catch Error: $e');
      return ApiResponse.error('Something went wrong 404');
    }
  }
}
