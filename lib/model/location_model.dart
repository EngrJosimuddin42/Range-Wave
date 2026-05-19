class LocationModel {
  double latitude;
  double longitude;
  dynamic address;
  dynamic city;
  dynamic country;
  String id;
  String userId;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.country,
    required this.id,
    required this.userId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    address: json["address"],
    city: json["city"],
    country: json["country"],
    id: json["id"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "city": city,
    "country": country,
    "id": id,
    "user_id": userId,
  };
}
