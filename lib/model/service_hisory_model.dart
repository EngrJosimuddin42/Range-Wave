class ServiceHistoryModel {
  final String bookingId;
  final String mechanicName;
  final String carBrand;
  final String carModel;
  final String status;
  final double price;
  final DateTime serviceDate;

  ServiceHistoryModel({
    required this.bookingId,
    required this.mechanicName,
    required this.carBrand,
    required this.carModel,
    required this.status,
    required this.price,
    required this.serviceDate,
  });

  factory ServiceHistoryModel.fromJson(Map<String, dynamic> json) =>
      ServiceHistoryModel(
        bookingId: json["booking_id"] ?? "",
        mechanicName: json["mechanic_name"] ?? json["customer_name"] ?? "N/A",
        carBrand: json["car_brand"] ?? "",
        carModel: json["car_model"] ?? "",
        status: json["status"] ?? "",
        price: (json["price"] ?? 0).toDouble(),
        serviceDate: json["service_date"] != null
            ? DateTime.parse(json["service_date"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
    "booking_id": bookingId,
    "mechanic_name": mechanicName,
    "car_brand": carBrand,
    "car_model": carModel,
    "status": status,
    "price": price,
    "service_date": serviceDate.toIso8601String(),
  };
}