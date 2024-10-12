class UserLoginModel {
  final String accessToken, refreshToken;
  final bool isNew;

  UserLoginModel.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'],
        isNew = json['isNew'];
}
