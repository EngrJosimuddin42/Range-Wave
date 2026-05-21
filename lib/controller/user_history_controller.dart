import 'package:get/get.dart';
import '../model/service_request_model.dart';
import '../service/service_request_service.dart';

class UserHistoryController extends GetxController {
  final ServiceRequestService _service = ServiceRequestService();

  RxList<String> chips = <String>[
    'All',
    'Upcoming',
    'Completed',
    'Running',
  ].obs;

  RxInt selectedChipIndex = 0.obs;

  RxList<ServiceRequestModel> serviceHistoryList = <ServiceRequestModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistoryData();
  }

  Future<void> fetchHistoryData() async {
    try {
      isLoading.value = true;
      final result = await _service.getUserServiceHistory();

      if (result.success && result.data != null) {
        serviceHistoryList.value = result.data!;
      } else {
        Get.snackbar("Error", result.error ?? "Failed to load history");
      }
    } catch (e) {
      print("Controller Exception: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}