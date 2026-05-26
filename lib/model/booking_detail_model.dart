class BookingCarIssue {
  final String id;
  final String severity;
  final int    confidenceLevel;
  final String summary;
  final String issue;
  final String serviceDate;
  final String serviceTime;
  final String brand;
  final String model;

  BookingCarIssue({
    required this.id,
    required this.severity,
    required this.confidenceLevel,
    required this.summary,
    required this.issue,
    required this.serviceDate,
    required this.serviceTime,
    required this.brand,
    required this.model,
  });

  factory BookingCarIssue.fromJson(Map<String, dynamic> json) =>
      BookingCarIssue(
        id               : json['id']               ?? '',
        severity         : json['severity']         ?? '',
        confidenceLevel  : (json['confidence_level'] as num?)?.toInt() ?? 0,
        summary          : json['summary']          ?? '',
        issue            : json['issue']            ?? '',
        serviceDate      : json['service_date']     ?? '',
        serviceTime      : json['service_time']     ?? '',
        brand            : json['brand']            ?? '',
        model            : json['model']            ?? '',
      );
}

class BookingUser {
  final String id;
  final String email;
  final String fullName;
  final String avatarUrl;

  BookingUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) => BookingUser(
    id        : json['id']          ?? '',
    email     : json['email']       ?? '',
    fullName  : json['full_name']   ?? '',
    avatarUrl : json['avatar_url']  ?? '',
  );
}

class BookingDetailModel {
  final String id;
  final String status;
  final Map<String, dynamic> costDetails;
  final double totalCost;
  final BookingCarIssue carIssue;
  final BookingUser user;

  BookingDetailModel({
    required this.id,
    required this.status,
    required this.costDetails,
    required this.totalCost,
    required this.carIssue,
    required this.user,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) =>
      BookingDetailModel(
        id          : json['id']          ?? '',
        status      : json['status']      ?? '',
        costDetails : Map<String, dynamic>.from(json['cost_details'] ?? {}),
        totalCost   : (json['total_cost'] as num?)?.toDouble() ?? 0.0,
        carIssue    : BookingCarIssue.fromJson(json['car_issue'] ?? {}),
        user        : BookingUser.fromJson(json['user'] ?? {}),
      );

  // ✅ status → step number
  int get stepIndex {
    switch (status.toLowerCase()) {
      case 'pending'    : return 0;
      case 'inspecting' : return 1;
      case 'repairing'  : return 2;
      case 'completed'  : return 3;
      default           : return 0;
    }
  }
}