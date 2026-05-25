import 'package:get/get.dart';
import 'package:range_wave/model/mechanic_portfolio_model.dart';
import 'package:range_wave/model/recommended_mechanic_model.dart';
import 'package:range_wave/service/mechanic_portfolio_service.dart';

class MechanicPortfolioController extends GetxController {

  final MechanicPortfolioService _service = MechanicPortfolioService();

  final Rxn<MechanicPortfolioModel> mechanic = Rxn<MechanicPortfolioModel>();
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is RecommendedMechanicModel) {
      final RecommendedMechanicModel data =
      Get.arguments as RecommendedMechanicModel;
      fetchMechanicDetails(data.mechanicId);
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