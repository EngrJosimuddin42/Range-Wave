import 'package:range_wave/core/app_credentials.dart';

class CarListModel {
  final int year;
  final String tagNumber;
  final String userId;
  final DateTime createdAt;
  final String model;
  final String brand;
  final String licensePlate;
  final String carImageId;
  final String imageUrl;
  final String id;
  final DateTime updatedAt;

  CarListModel({
    required this.year,
    required this.tagNumber,
    required this.userId,
    required this.createdAt,
    required this.model,
    required this.brand,
    required this.licensePlate,
    required this.carImageId,
    required this.imageUrl,
    required this.id,
    required this.updatedAt,
  });

  factory CarListModel.fromJson(Map<String, dynamic> json) => CarListModel(
    year: json["year"],
    tagNumber: json["tag_number"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    model: json["model"],
    brand: json["brand"] ?? "",
    licensePlate: json["license_plate"] ?? "",
    carImageId: json["car_image_id"] ?? "",
    imageUrl: AppCredentials.resolveUrl(
      (json["image_url"] ?? json["car_image"] ?? json["image"] ?? '').toString(),
    ),
    id: json["id"] ?? "",
    updatedAt: DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "tag_number": tagNumber,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "model": model,
    "brand": brand,
    "license_plate": licensePlate,
    "car_image_id": carImageId,
    "image_url": imageUrl,
    "id": id,
    "updated_at": updatedAt.toIso8601String(),
  };
}