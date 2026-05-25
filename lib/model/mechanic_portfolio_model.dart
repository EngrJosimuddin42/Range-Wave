class MechanicCertificate {
  final String certificateImageUrl;
  final String certificateImageId;

  MechanicCertificate({
    required this.certificateImageUrl,
    required this.certificateImageId,
  });

  factory MechanicCertificate.fromJson(Map<String, dynamic> json) =>
      MechanicCertificate(
        certificateImageUrl: json['certificate_image_url'] ?? '',
        certificateImageId : json['certificate_image_id']  ?? '',
      );
}

class MechanicPortfolioModel {
  final String id;
  final String shopName;
  final String initialCharge;
  final int    yearOfExperience;
  final List<String> specialist;
  final String fullName;
  final String bio;
  final String avatarUrl;
  final double avgRating;
  final int    totalRating;
  final List<MechanicCertificate> certificates;
  final double latitude;
  final double longitude;

  MechanicPortfolioModel({
    required this.id,
    required this.shopName,
    required this.initialCharge,
    required this.yearOfExperience,
    required this.specialist,
    required this.fullName,
    required this.bio,
    required this.avatarUrl,
    required this.avgRating,
    required this.totalRating,
    required this.certificates,
    required this.latitude,
    required this.longitude,
  });

  factory MechanicPortfolioModel.fromJson(Map<String, dynamic> json) =>
      MechanicPortfolioModel(
        id               : json['id']                ?? '',
        shopName         : json['shop_name']          ?? '',
        initialCharge    : json['initial_charge']?.toString() ?? '0',
        yearOfExperience : (json['year_of_experience'] as num?)?.toInt() ?? 0,
        specialist       : List<String>.from(json['specialist'] ?? []),
        fullName         : json['full_name']          ?? '',
        bio              : json['bio']?.toString()    ?? '',
        avatarUrl        : json['avatar_url']         ?? '',
        avgRating        : (json['avg_rating']  as num?)?.toDouble() ?? 0.0,
        totalRating      : (json['total_rating'] as num?)?.toInt()   ?? 0,
        certificates     : (json['certificates'] as List<dynamic>?)
            ?.map((e) => MechanicCertificate.fromJson(e))
            .toList() ?? [],
        latitude         : (json['latitude']  as num?)?.toDouble() ?? 0.0,
        longitude        : (json['longitude'] as num?)?.toDouble() ?? 0.0,
      );
}