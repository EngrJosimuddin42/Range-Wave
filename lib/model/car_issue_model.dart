// lib/model/car_issue_model.dart

class CarIssueModel {
  final String carId;
  final String userId;
  final String serviceDate;
  final String serviceTime;
  final String summary;
  final String issue;
  final String severityLevel;
  final int confidenceLevel;
  final double latitude;
  final double longitude;
  final String id;

  CarIssueModel({
    required this.carId,
    required this.userId,
    required this.serviceDate,
    required this.serviceTime,
    required this.summary,
    required this.issue,
    required this.severityLevel,
    required this.confidenceLevel,
    required this.latitude,
    required this.longitude,
    required this.id,
  });

  factory CarIssueModel.fromJson(Map<String, dynamic> json) => CarIssueModel(
    carId           : json['car_id']           ?? '',
    userId          : json['user_id']          ?? '',
    serviceDate     : json['service_date']      ?? '',
    serviceTime     : json['service_time']      ?? '',
    summary         : json['summary']           ?? '',
    issue           : json['issue']             ?? '',
    severityLevel   : json['severity_level']    ?? '',
    confidenceLevel : (json['confidence_level'] as num?)?.toInt() ?? 0,
    latitude        : (json['latitude']  as num?)?.toDouble() ?? 0.0,
    longitude       : (json['longitude'] as num?)?.toDouble() ?? 0.0,
    id              : json['id']               ?? '',
  );
}