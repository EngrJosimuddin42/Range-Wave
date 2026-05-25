import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/custom_http.dart';
import 'package:range_wave/model/recommended_mechanic_model.dart';

class RecommendedMechanicService {

  Future<ApiResponse<List<RecommendedMechanicModel>>> getMechanics({
    required String carIssueId,
  }) async {
    try {
      final response = await CustomHttp.get(
        endpoint: 'customer/get-mechanics?car_issue_id=$carIssueId',
        needAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonList = response.data;
        final list = jsonList
            .map((e) => RecommendedMechanicModel.fromJson(e))
            .toList();
        return ApiResponse.success(list);
      } else {
        return ApiResponse.error(
          response.error ?? 'Failed to fetch mechanics',
        );
      }
    } catch (e) {
      print('GET MECHANICS ERROR: $e');
      return ApiResponse.error('Something went wrong');
    }
  }
}