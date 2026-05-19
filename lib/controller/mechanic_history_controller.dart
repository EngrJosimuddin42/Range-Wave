import 'package:get/get.dart';

import '../core/utils/color/app_colors.dart';
import '../model/service_hisory_model.dart';

class MechanicHistoryController extends GetxController {
  RxList<String> chips = <String>[
    'All',
    'Upcoming',
    'Completed',
    'Running',
  ].obs;

  RxInt selectedChipIndex = 0.obs;

  final List<ServiceHistoryModel> serviceHistoryList = [
    ServiceHistoryModel(
      name: 'Honda Civic',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: '\$1250',
      priceTextColor: AppColors.blue,
      priceContainerColor: AppColors.blueLight,
    ),
    ServiceHistoryModel(
      name: 'Honda Civic',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: '\$1250',
      priceTextColor: AppColors.blue,
      priceContainerColor: AppColors.blueLight,
    ),
    ServiceHistoryModel(
      name: 'Mr. Alex',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: 'Upcoming',
      priceTextColor: AppColors.primary,
      priceContainerColor: AppColors.orangeLight,
    ),
    ServiceHistoryModel(
      name: 'Honda Civic',
      carAndDate: 'Honda Civic/23 Oct 2025',
      statusValue: 'Running',
      priceTextColor: AppColors.green,
      priceContainerColor: AppColors.greenLight,
    ),
  ];


}
