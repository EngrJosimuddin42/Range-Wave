import 'package:get/get.dart';
import 'package:range_wave/model/service_request_model.dart';
import 'package:range_wave/service/service_request_service.dart';

class ServiceRequestController extends GetxController {
  ServiceRequestService serviceRequestService = ServiceRequestService();

  RxList<ServiceRequestModel> serviceRequests = <ServiceRequestModel>[].obs;
  RxBool isLoading = false.obs;

  Future<bool> incomingServiceRequests({String status = 'pending'}) async {
    isLoading.value = true;
    final response = await serviceRequestService.getServiceRequests(status);

    if (response.success) {
      isLoading.value = false;
      serviceRequests.assignAll(response.data ?? []);
      return true;
    } else {
      isLoading.value = false;
      return false;
    }
  }

  @override
  void onInit() {
    incomingServiceRequests();
    super.onInit();
    print('===== ServiceRequestController onInit =====');
  }
}
