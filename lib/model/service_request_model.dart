class ServiceRequestModel {
  final String bookingId;
  final String status;
  final String customerId;
  final String customerEmail;
  final String customerName;
  final dynamic customerAvatar;
  final String carBrand;
  final String carModel;
  final String issueSummary;
  final String issueDetail;
  final String severityLevel;
  final DateTime serviceDate;
  final String serviceTime;
  final String? distance;
  final String? estimatedAmount;

  ServiceRequestModel({
    required this.bookingId,
    required this.status,
    required this.customerId,
    required this.customerEmail,
    required this.customerName,
    required this.customerAvatar,
    required this.carBrand,
    required this.carModel,
    required this.issueSummary,
    required this.issueDetail,
    required this.severityLevel,
    required this.serviceDate,
    required this.serviceTime,
    this.distance,
    this.estimatedAmount,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      ServiceRequestModel(
        bookingId: json["booking_id"],
        status: json["status"],
        customerId: json["customer_id"],
        customerEmail: json["customer_email"],
        customerName: json["customer_name"],
        customerAvatar: json["customer_avatar"],
        carBrand: json["car_brand"],
        carModel: json["car_model"],
        issueSummary: json["issue_summary"],
        issueDetail: json["issue_detail"],
        severityLevel: json["severity_level"],
        serviceDate: DateTime.parse(json["service_date"]),
        serviceTime: json["service_time"],
        distance: json["distance"]?.toString(),
        estimatedAmount: json["estimated_amount"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "booking_id": bookingId,
    "status": status,
    "customer_id": customerId,
    "customer_email": customerEmail,
    "customer_name": customerName,
    "customer_avatar": customerAvatar,
    "car_brand": carBrand,
    "car_model": carModel,
    "issue_summary": issueSummary,
    "issue_detail": issueDetail,
    "severity_level": severityLevel,
    "service_date":
    "${serviceDate.year.toString().padLeft(4, '0')}-${serviceDate.month.toString().padLeft(2, '0')}-${serviceDate.day.toString().padLeft(2, '0')}",
    "service_time": serviceTime,
    "distance": distance,
    "estimated_amount": estimatedAmount,
  };
}