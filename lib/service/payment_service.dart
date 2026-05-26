import 'package:range_wave/core/utils/api_response.dart';
import 'package:range_wave/core/utils/custom_http.dart';

class PaymentService {

  Future<ApiResponse<String>> createPaymentIntent({
    required String bookingId,
  }) async {
    try {
      final response = await CustomHttp.post(
        endpoint: 'payments/create-payment-intent/$bookingId',
        needAuth: true,
        body: {},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final clientSecret = response.data['client_secret']?.toString() ?? '';
        return ApiResponse.success(clientSecret);
      } else {
        return ApiResponse.error(response.error ?? 'Payment failed');
      }
    } catch (e) {
      print('PAYMENT ERROR: $e');
      return ApiResponse.error('Something went wrong');
    }
  }
}