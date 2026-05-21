import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/model/service_request_model.dart';
import '../core/utils/custom_http.dart';

class ServiceRequestService {

  /// -------------------- Get Mechanic Service Requests -------------------- ///
  Future<ApiResponse<List<ServiceRequestModel>>> getServiceRequests(
      String status,
      ) async {
    try {
      final String endpoint = status.isEmpty
          ? 'common/all-bookings'
          : 'common/all-bookings?booking_status=$status';

      final response = await CustomHttp.get(
        endpoint: endpoint,
        needAuth: true,
        showFloatingError: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonList = response.data;
        final List<ServiceRequestModel> serviceRequests = jsonList
            .map((json) => ServiceRequestModel.fromJson(json))
            .toList();
        return ApiResponse.success(serviceRequests);
      } else {
        return ApiResponse.error(
          response.error ?? 'Failed to fetch service requests',
        );
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error('Something went wrong 404');
    }
  }

  /// -------------------- Get User Service History -------------------- ///
  Future<ApiResponse<List<ServiceRequestModel>>> getUserServiceHistory({
    String status = '',
  }) async {
    try {
      final String endpoint = status.isEmpty
          ? 'common/all-bookings'
          : 'common/all-bookings?booking_status=$status';

      final response = await CustomHttp.get(
        endpoint: endpoint,
        needAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonList = response.data;
        final List<ServiceRequestModel> historyList = jsonList
            .map((json) => ServiceRequestModel.fromJson(json))
            .toList();
        return ApiResponse.success(historyList);
      } else {
        return ApiResponse.error(
          response.error ?? 'Failed to fetch service history',
        );
      }
    } catch (e) {
      print('FETCH HISTORY ERROR: $e');
      return ApiResponse.error('Something went wrong 404');
    }
  }
}