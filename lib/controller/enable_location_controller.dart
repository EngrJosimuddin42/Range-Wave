import 'package:get/get.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/service/location_service.dart';

class EnableLocationController extends GetxController {
  final LocationService _locationService = LocationService();

  RxBool isLoading = false.obs;

  Future<bool> setCurrentLocation(double latitude, double longitude) async {
    isLoading.value = true;
    print('Okay jvai');
    final userId = await AppHelper.instance.getUserId();
    if (userId == null) {
      isLoading.value = false;
      return false;
    }
    print(userId);
    final response = await _locationService.currentLocation(
      latitude,
      longitude,
      userId,
    );
    if (response.data != null) {
      isLoading.value = false;
      return true;
    } else {
      isLoading.value = false;
      if (response.error != null) {
        showCustomToast(text: response.error!);
      }
      return false;
    }
  }
}
