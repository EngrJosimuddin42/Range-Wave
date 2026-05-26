import 'package:get/get.dart';
import 'package:range_wave/model/booking_detail_model.dart';
import 'package:range_wave/model/booking_model.dart';
import 'package:range_wave/service/booking_detail_service.dart';

class ServiceInProgressController extends GetxController {

  final BookingDetailService _service = BookingDetailService();

  final Rxn<BookingDetailModel> booking  = Rxn<BookingDetailModel>();
  final RxBool                  isLoading = RxBool(false);
  final RxInt                   currentStep = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is BookingModel) {
      final BookingModel b = Get.arguments as BookingModel;
      _fetchBookingDetail(b.id);
    }
  }

  Future<void> _fetchBookingDetail(String bookingId) async {
    isLoading.value = true;
    try {
      final response = await _service.getBookingDetail(bookingId: bookingId);
      if (response.data != null) {
        booking.value     = response.data;
        currentStep.value = response.data!.stepIndex; // ✅ status → step
      }
    } finally {
      isLoading.value = false;
    }
  }

  void updateStep(int step) => currentStep.value = step;

  @override
  void onClose() {
    currentStep.value = 0;
    super.onClose();
  }
}