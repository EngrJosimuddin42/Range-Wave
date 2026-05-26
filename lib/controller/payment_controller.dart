import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/model/booking_detail_model.dart';
import 'package:range_wave/service/payment_service.dart';

class PaymentCard {
  final String name;
  final String cardNumber;
  final String holderName;
  final String mmyy;

  PaymentCard({
    required this.name,
    required this.cardNumber,
    required this.holderName,
    required this.mmyy,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'cardNumber': cardNumber,
    'holderName': holderName,
    'mmyy': mmyy,
  };

  factory PaymentCard.fromMap(Map<String, dynamic> map) => PaymentCard(
    name: map['name'] ?? '',
    cardNumber: map['cardNumber'] ?? '',
    holderName: map['holderName'] ?? '',
    mmyy: map['mmyy'] ?? '',
  );
}

class PaymentController extends GetxController {

  // ── existing ──────────────────────────────────────────────
  final PaymentService _paymentService = PaymentService(); // ✅ যোগ করো
  RxList<PaymentCard> paymentCards = <PaymentCard>[].obs;
  RxInt  selectedIndex = 0.obs;
  RxBool isLoading     = RxBool(false);              // ✅ যোগ করো

  @override
  void onInit() {
    super.onInit();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString('payment_cards');

    if (cardsJson != null) {
      final List decoded = jsonDecode(cardsJson);
      paymentCards.assignAll(
        decoded.map((e) => PaymentCard.fromMap(
            Map<String, dynamic>.from(e))).toList(),
      );
    } else {
      paymentCards.assignAll([
        PaymentCard(name: 'Stripe',    cardNumber: '', holderName: '', mmyy: ''),
        PaymentCard(name: 'Apple Pay', cardNumber: '', holderName: '', mmyy: ''),
      ]);
    }
    selectedIndex.value = prefs.getInt('selected_index') ?? 0;
  }

  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
    jsonEncode(paymentCards.map((e) => e.toMap()).toList());
    await prefs.setString('payment_cards', encoded);
    await prefs.setInt('selected_index', selectedIndex.value);
  }

  void selectCard(int index) {
    selectedIndex.value = index;
    _saveCards();
  }

  void addCard({
    required String holderName,
    required String cardNumber,
    required String mmyy,
  }) {
    paymentCards.add(
      PaymentCard(
        name: holderName,
        cardNumber: cardNumber,
        holderName: holderName,
        mmyy: mmyy,
      ),
    );
    selectedIndex.value = paymentCards.length - 1;
    _saveCards();
  }

  Future<void> clearCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('payment_cards');
    await prefs.remove('selected_index');
    paymentCards.assignAll([
      PaymentCard(name: 'Stripe',    cardNumber: '', holderName: '', mmyy: ''),
      PaymentCard(name: 'Apple Pay', cardNumber: '', holderName: '', mmyy: ''),
    ]);
    selectedIndex.value = 0;
  }

  // ✅ নতুন — Stripe payment ───────────────────────────────
  Future<void> processPayment({
    required BookingDetailModel booking,
  }) async {
    isLoading.value = true;

    try {
      // Step 1: Payment intent create
      final response = await _paymentService.createPaymentIntent(
        bookingId: booking.id,
      );

      if (response.data == null || response.data!.isEmpty) {
        showCustomToast(text: response.error ?? 'Payment failed');
        return;
      }

      // Step 2: Stripe payment sheet init
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: response.data!,
          merchantDisplayName      : 'Range Wave',
        ),
      );

      // Step 3: Present sheet
      await Stripe.instance.presentPaymentSheet();

      // Step 4: Success
      showCustomToast(text: 'Payment successful!');
      Get.toNamed(AppRoutes.paymentSuccessful);

    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        showCustomToast(text: 'Payment cancelled');
      } else {
        showCustomToast(
          text: e.error.localizedMessage ?? 'Payment failed',
        );
      }
    } catch (e) {
      showCustomToast(text: 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}