import 'package:get/get.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/service/location_service.dart';

class EnableLocationController extends GetxController {
  final LocationService _locationService = LocationService();

  RxBool isLoading = false.obs;

  Future<bool> setCurrentLocation(double latitude, double longitude) async {
    isLoading.value = true;
    try {
      final userId = await AppHelper.instance.getUserId();
      if (userId == null) {
        showCustomToast(text: 'User not found. Please sign in again.');
        return false;
      }

      final response = await _locationService.currentLocation(
        latitude,
        longitude,
        userId,
      );

      if (response.data != null) {
        return true;
      } else {
        showCustomToast(text: response.error ?? 'Failed to update location');
        return false;
      }
    } catch (e) {
      showCustomToast(text: 'Something went wrong.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}