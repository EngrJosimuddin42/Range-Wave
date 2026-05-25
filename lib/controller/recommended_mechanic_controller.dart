import 'package:get/get.dart';
import 'package:range_wave/model/car_issue_model.dart';
import 'package:range_wave/model/recommended_mechanic_model.dart';
import 'package:range_wave/service/recommended_mechanic_service.dart';

class RecommendedMechanicController extends GetxController {

  final RecommendedMechanicService _service = RecommendedMechanicService();

  final RxList<RecommendedMechanicModel> mechanicList = RxList();
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is CarIssueModel) {
      final CarIssueModel issue = Get.arguments as CarIssueModel;
      fetchMechanics(issue.id);
    }
  }

  Future<void> fetchMechanics(String carIssueId) async {
    isLoading.value = true;
    try {
      final response = await _service.getMechanics(carIssueId: carIssueId);
      if (response.data != null) {
        mechanicList.assignAll(response.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }
}