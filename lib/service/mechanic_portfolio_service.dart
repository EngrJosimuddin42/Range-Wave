import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/custom_http.dart';
import 'package:range_wave/model/mechanic_portfolio_model.dart';

class MechanicPortfolioService {

  Future<ApiResponse<MechanicPortfolioModel>> getMechanicDetails({
    required String mechanicId,
  }) async {
    try {
      final response = await CustomHttp.get(
        endpoint: 'common/get-mechanic-data/$mechanicId',
        needAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = MechanicPortfolioModel.fromJson(response.data);
        return ApiResponse.success(model);
      } else {
        return ApiResponse.error(
          response.error ?? 'Failed to fetch mechanic details',
        );
      }
    } catch (e) {
      print('GET MECHANIC DETAILS ERROR: $e');
      return ApiResponse.error('Something went wrong');
    }
  }
}