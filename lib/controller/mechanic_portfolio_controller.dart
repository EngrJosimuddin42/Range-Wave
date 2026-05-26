import 'package:get/get.dart';
import 'package:range_wave/model/mechanic_portfolio_model.dart';
import 'package:range_wave/model/recommended_mechanic_model.dart';
import 'package:range_wave/service/mechanic_portfolio_service.dart';

class MechanicPortfolioController extends GetxController {

  final MechanicPortfolioService _service = MechanicPortfolioService();

  final Rxn<MechanicPortfolioModel> mechanic = Rxn<MechanicPortfolioModel>();
  final RxBool isLoading = RxBool(false);
  String carIssueId = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      final RecommendedMechanicModel mechanic =
      args['mechanic'] as RecommendedMechanicModel;
      carIssueId = args['issue_id'] ?? '';
      print('MECHANIC ID: ${mechanic.mechanicId}');
      print('ISSUE ID: $carIssueId');
      fetchMechanicDetails(mechanic.mechanicId);
    }
  }


  Future<void> fetchMechanicDetails(String mechanicId) async {
    isLoading.value = true;
    try {
      final response = await _service.getMechanicDetails(
        mechanicId: mechanicId,
      );
      if (response.data != null) {
        mechanic.value = response.data;
      }
    } finally {
      isLoading.value = false;
    }
  }
}