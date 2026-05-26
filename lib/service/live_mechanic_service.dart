import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/custom_http.dart';

class LiveMechanicService {

  // ── Status update ─────────────────────────────────────────
  Future<ApiResponse<bool>> changeBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    try {
      final response = await CustomHttp.patch(
        endpoint: 'common/change-booking-status/$bookingId',
        needAuth: true,
        body: {'status': status},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true);
      }
      return ApiResponse.error(response.error ?? 'Failed');
    } catch (e) {
      return ApiResponse.error('Something went wrong');
    }
  }

  // ── Add price details ─────────────────────────────────────
  Future<ApiResponse<bool>> addPriceDetails({
    required String bookingId,
    required Map<String, dynamic> priceDetails,
  }) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'mechanic/add-price-details/$bookingId',
        needAuth: true,
        body: priceDetails,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true);
      }
      return ApiResponse.error(response.error ?? 'Failed');
    } catch (e) {
      return ApiResponse.error('Something went wrong');
    }
  }
}