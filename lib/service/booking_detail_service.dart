import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/custom_http.dart';
import 'package:range_wave/model/booking_detail_model.dart';

class BookingDetailService {

  Future<ApiResponse<BookingDetailModel>> getBookingDetail({
    required String bookingId,
  }) async {
    try {
      final response = await CustomHttp.get(
        endpoint: 'common/all-bookings?booking_status=',
        needAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> list = response.data;
        // booking id দিয়ে filter করো
        final json = list.firstWhere(
              (e) => e['id'] == bookingId,
          orElse: () => list.isNotEmpty ? list.first : null,
        );
        if (json == null) return ApiResponse.error('Booking not found');
        return ApiResponse.success(BookingDetailModel.fromJson(json));
      } else {
        return ApiResponse.error(response.error ?? 'Failed');
      }
    } catch (e) {
      print('GET BOOKING DETAIL ERROR: $e');
      return ApiResponse.error('Something went wrong');
    }
  }
}