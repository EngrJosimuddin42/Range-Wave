import 'dart:ui';

class ServiceHistoryModel {
  final String name;
  final String carAndDate;
  final String statusValue;
  final Color priceTextColor;
  final Color priceContainerColor;

  ServiceHistoryModel({
    required this.name,
    required this.carAndDate,
    required this.statusValue,
    required this.priceTextColor,
    required this.priceContainerColor,
  });
}
