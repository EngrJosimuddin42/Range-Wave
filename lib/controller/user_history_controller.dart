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

  // Chip index → API status string mapping
  final Map<int, String> statusMap = {
    0: '',            // All
    1: 'upcoming',
    2: 'completed',
    3: 'running',
  };

  RxList<ServiceRequestModel> serviceHistoryList = <ServiceRequestModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistoryData();

    //  Chip change হলে auto filter
    ever(selectedChipIndex, (_) => fetchHistoryData());
  }

  void resetToDefault() {
    selectedChipIndex.value = 0;
  }

  Future<void> fetchHistoryData() async {
    try {
      isLoading.value = true;

      //  Selected chip অনুযায়ী status পাঠাচ্ছে
      final String status = statusMap[selectedChipIndex.value] ?? '';
      final result = await _service.getUserServiceHistory(status: status);

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