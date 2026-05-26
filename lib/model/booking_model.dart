class BookingModel {
  final String id;
  final String bookedBy;
  final String mechanicId;
  final String userCarIssueId;
  final String status;
  final String createdAt;

  BookingModel({
    required this.id,
    required this.bookedBy,
    required this.mechanicId,
    required this.userCarIssueId,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id             : json['id']               ?? '',
    bookedBy       : json['booked_by']        ?? '',
    mechanicId     : json['mechanic_id']      ?? '',
    userCarIssueId : json['user_car_issue_id'] ?? '',
    status         : json['status']           ?? '',
    createdAt      : json['created_at']       ?? '',
  );
}