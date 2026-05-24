import 'package:get/get.dart';
import '../model/service_request_model.dart';
import '../service/service_request_service.dart';

class MechanicHistoryController extends GetxController {
  final ServiceRequestService _service = ServiceRequestService();

  RxList<String> chips = <String>[
    'All',
    'Upcoming',
    'Completed',
    'Running',
  ].obs;

  RxInt selectedChipIndex = 0.obs;

  // ✅ UserHistoryController এর মতো statusMap
  final Map<int, String> statusMap = {
    0: '',            // All
    1: 'upcoming',
    2: 'completed',
    3: 'running',
  };

  RxList<ServiceRequestModel> mechanicHistoryList = <ServiceRequestModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMechanicHistory();

    // ✅ Chip change হলে auto filter
    ever(selectedChipIndex, (_) => fetchMechanicHistory());
  }

  // ✅ resetToDefault যোগ
  void resetToDefault() {
    selectedChipIndex.value = 0;
  }

  Future<void> fetchMechanicHistory() async {
    try {
      isLoading.value = true;

      // ✅ statusMap থেকে status নিচ্ছে
      final String status = statusMap[selectedChipIndex.value] ?? '';
      final result = await _service.getServiceRequests(status);

      if (result.success && result.data != null) {
        mechanicHistoryList.value = result.data!;
      } else {
        Get.snackbar("Error", result.error ?? "Failed to load mechanic history");
      }
    } catch (e) {
      print("Mechanic Controller Exception: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}