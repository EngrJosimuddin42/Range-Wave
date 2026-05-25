class RecommendedMechanicModel {
  final String mechanicId;
  final double distanceKm;
  final double latitude;
  final double longitude;
  final String fullName;
  final String avatarUrl;
  final String shopName;
  final String initialCharge;
  final double avgRating;
  final int totalRating;

  RecommendedMechanicModel({
    required this.mechanicId,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
    required this.fullName,
    required this.avatarUrl,
    required this.shopName,
    required this.initialCharge,
    required this.avgRating,
    required this.totalRating,
  });

  factory RecommendedMechanicModel.fromJson(Map<String, dynamic> json) =>
      RecommendedMechanicModel(
        mechanicId    : json['mechanic_id']    ?? '',
        distanceKm    : (json['distance_km']   as num?)?.toDouble() ?? 0.0,
        latitude      : (json['latitude']      as num?)?.toDouble() ?? 0.0,
        longitude     : (json['longitude']     as num?)?.toDouble() ?? 0.0,
        fullName      : json['full_name']       ?? '',
        avatarUrl     : json['avatar_url']      ?? '',
        shopName      : json['shop_name']       ?? '',
        initialCharge : json['initial_charge']?.toString() ?? '0',
        avgRating     : (json['avg_rating']    as num?)?.toDouble() ?? 0.0,
        totalRating   : (json['total_rating']  as num?)?.toInt()    ?? 0,
      );
}