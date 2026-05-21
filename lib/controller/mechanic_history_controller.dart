import 'package:get/get.dart';
import '../model/service_request_model.dart';
import '../service/service_request_service.dart';

class MechanicHistoryController extends GetxController {
  final ServiceRequestService _service = ServiceRequestService();

  // চিপসের লিস্ট
  RxList<String> chips = <String>[
    'All',
    'Upcoming',
    'Completed',
    'Running',
  ].obs;

  RxInt selectedChipIndex = 0.obs;

  RxList<ServiceRequestModel> mechanicHistoryList = <ServiceRequestModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('===== MechanicHistoryController onInit =====');
    fetchMechanicHistory(chips[selectedChipIndex.value]);
  }


  void changeChipIndex(int index) {
    selectedChipIndex.value = index;
    fetchMechanicHistory(chips[index]);
  }

  Future<void> fetchMechanicHistory(String status) async {
    try {
      isLoading.value = true;
      final String apiStatus = status == 'All' ? '' : status.toLowerCase();
      final result = await _service.getServiceRequests(apiStatus);

      print('HISTORY API: success=${result.success}, error=${result.error}, data=${result.data}');


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