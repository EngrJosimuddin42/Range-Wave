import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  RxList<PaymentCard> paymentCards = <PaymentCard>[].obs;
  RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCards();
  }

  // SharedPreferences থেকে load
  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString('payment_cards');

    if (cardsJson != null) {
      final List decoded = jsonDecode(cardsJson);
      paymentCards.assignAll(
        decoded.map((e) => PaymentCard.fromMap(Map<String, dynamic>.from(e))).toList(),
      );
    } else {
      //  প্রথমবার default cards
      paymentCards.assignAll([
        PaymentCard(name: 'Stripe', cardNumber: '', holderName: '', mmyy: ''),
        PaymentCard(name: 'Apple Pay', cardNumber: '', holderName: '', mmyy: ''),
      ]);
    }

    selectedIndex.value = prefs.getInt('selected_index') ?? 0;
  }

  //  SharedPreferences এ save
  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(paymentCards.map((e) => e.toMap()).toList());
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

  //  Logout এ clear করুন
  Future<void> clearCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('payment_cards');
    await prefs.remove('selected_index');
    paymentCards.assignAll([
      PaymentCard(name: 'Stripe', cardNumber: '', holderName: '', mmyy: ''),
      PaymentCard(name: 'Apple Pay', cardNumber: '', holderName: '', mmyy: ''),
    ]);
    selectedIndex.value = 0;
  }
}