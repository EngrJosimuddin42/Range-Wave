import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/model/service_request_model.dart';
import 'package:range_wave/service/live_mechanic_service.dart';

class LiveMechanicController extends GetxController {

  final LiveMechanicService _service = LiveMechanicService();

  late ServiceRequestModel booking;
  final RxInt  currentStep  = RxInt(0);
  final RxBool isLoading    = RxBool(false);

  // ── Bill items — dynamic key/value ────────────────────────
  final RxList<BillItem> billItems = RxList<BillItem>();

  // ── Status list — step এর সাথে match ─────────────────────
  final List<String> statusList = [
    'arrived',
    'inspecting',
    'repairing',
    'completed',
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ServiceRequestModel) {
      booking = Get.arguments as ServiceRequestModel;
      // booking এর current status থেকে step set করো
      currentStep.value = _statusToStep(booking.status);
    }
  }

  int _statusToStep(String status) {
    switch (status.toLowerCase()) {
      case 'arrived'    : return 0;
      case 'inspecting' : return 1;
      case 'repairing'  : return 2;
      case 'completed'  : return 3;
      default           : return 0;
    }
  }

  // ── Change status ──────────────────────────────────────────
  Future<void> nextStep() async {
    final nextIndex = currentStep.value + 1;
    if (nextIndex >= statusList.length) return;

    isLoading.value = true;
    try {
      final response = await _service.changeBookingStatus(
        bookingId: booking.bookingId,
        status   : statusList[nextIndex],
      );

      if (response.data == true) {
        currentStep.value = nextIndex;
        showCustomToast(
          text     : 'Status updated to ${statusList[nextIndex]}',
          toastType: ToastTypesInfo(ToastTypes.success),
        );
      } else {
        showCustomToast(text: response.error ?? 'Update failed');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ── Add bill item ──────────────────────────────────────────
  void addBillItem() {
    billItems.add(BillItem());
  }

  void removeBillItem(int index) {
    billItems.removeAt(index);
  }

  // ── Submit bill ────────────────────────────────────────────
  Future<void> submitBill() async {
    if (billItems.isEmpty) {
      showCustomToast(text: 'Please add at least one bill item');
      return;
    }

    // ✅ dynamic key/value map বানাও
    final Map<String, dynamic> priceMap = {};
    for (var item in billItems) {
      final key   = item.nameController.text.trim();
      final value = double.tryParse(item.priceController.text.trim()) ?? 0.0;
      if (key.isNotEmpty) priceMap[key] = value;
    }

    if (priceMap.isEmpty) {
      showCustomToast(text: 'Please fill bill items');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _service.addPriceDetails(
        bookingId    : booking.bookingId,
        priceDetails : priceMap,
      );

      if (response.data == true) {
        showCustomToast(
          text     : 'Bill submitted successfully',
          toastType: ToastTypesInfo(ToastTypes.success),
        );
        await nextStep(); // ✅ bill submit হলে next step
      } else {
        showCustomToast(text: response.error ?? 'Failed');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ── Get Paid ───────────────────────────────────────────────
  Future<void> getPaid() async {
    isLoading.value = true;
    try {
      final response = await _service.changeBookingStatus(
        bookingId: booking.bookingId,
        status   : 'paid',
      );
      if (response.data == true) {
        Get.toNamed(AppRoutes.rateMechanic);  // Rate Customer screen
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (var item in billItems) item.dispose();
    super.onClose();
  }
}

// ── Bill item model ────────────────────────────────────────
class BillItem {
  final TextEditingController nameController  = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  void dispose() {
    nameController.dispose();
    priceController.dispose();
  }
}