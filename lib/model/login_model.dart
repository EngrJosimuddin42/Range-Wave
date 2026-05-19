class LoginModel {
  final String userId;
  final String role;
  final String accessToken;
  final String refreshToken;
  final int accessTokenValidTill;

  LoginModel({
    required this.userId,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenValidTill,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    userId: json["user_id"],
    role: json["role"],
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    accessTokenValidTill: json["access_token_valid_till"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "role": role,
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "access_token_valid_till": accessTokenValidTill,
  };
}
