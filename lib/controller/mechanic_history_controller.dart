import 'package:get/get.dart';
import 'package:flutter/material.dart';
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

  final Map<int, String> statusMap = {
    0: '',
    1: 'pending',
    2: 'completed',
    3: 'repairing',
  };

  RxList<ServiceRequestModel> mechanicHistoryList = <ServiceRequestModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("======== MechanicHistoryController Initialized ========");
    fetchMechanicHistory();

    // Chip change হলে auto filter
    ever(selectedChipIndex, (index) {
      debugPrint("🎯 Chip Changed! New Index: $index, Status Code: '${statusMap[index]}'");
      fetchMechanicHistory();
    });
  }

  void resetToDefault() {
    debugPrint("🔄 Resetting Chip Index to 0");
    selectedChipIndex.value = 0;
  }

  Future<void> fetchMechanicHistory() async {
    try {
      isLoading.value = true;
      final String status = statusMap[selectedChipIndex.value] ?? '';

      debugPrint("🚀 Fetching History API Started. Status Parameter: '$status'");

      final result = await _service.getServiceRequests(status);

      debugPrint("📦 API Response Received. Success Status: ${result.success}");

      if (result.success && result.data != null) {
        mechanicHistoryList.value = result.data!;
        debugPrint("✅ Successfully loaded ${result.data!.length} history items.");
      } else {
        debugPrint("❌ API Response Error: ${result.error}");
        Get.snackbar(
          "Error",
          result.error ?? "Failed to load mechanic history",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      // 🚨 এখানে কনসোলে বড় করে লাল বা পরিষ্কার মেসেজে ট্র্যাক প্রিন্ট হবে
      debugPrint("=========================================================");
      debugPrint("🚨 CRITICAL EXCEPTION IN MECHANIC CONTROLLER !!!");
      debugPrint("Error Message: $e");
      debugPrint("Stack Trace:\n$stackTrace");
      debugPrint("=========================================================");

      Get.snackbar(
        "Exception Caught",
        e.toString().split('\n').first, // প্রথম লাইনটি দেখাবে
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.2),
      );
    } finally {
      isLoading.value = false;
      debugPrint("🔚 Fetching History API Finished. Loading Status: false");
    }
  }
}