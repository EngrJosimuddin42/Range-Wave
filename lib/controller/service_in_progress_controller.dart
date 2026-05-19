import 'package:get/get.dart';

class ServiceInProgressController extends GetxController {
  var currentStep = 0.obs;

  void updateStep(int step) {
    currentStep.value = step;
  }

  @override
  void onClose() {
    currentStep.value = 0;
    super.onClose();
  }
}
