import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xive/models/user_login_model.dart';

class UserService {
  final dio = Dio();
  final baseUrl = dotenv.env['BASE_URL'];

  Future<UserLoginModel> kakaoLogin(String accessToken) async {
    UserLoginModel userLoginInstance;
    final response = await dio.post(
      "$baseUrl/kakao-login",
      data: {
        "accessToken": accessToken,
      },
    );
    if (response.statusCode == 200) {
      userLoginInstance = UserLoginModel.fromJson(response.data);
      return userLoginInstance;
    }
    throw Error();
    // todo 에러 처리 추가해서 에러 화면으로 이동해야함
  }

  Future<UserLoginModel> appleLogin(
      String code, String idToken, String email, String name) async {
    UserLoginModel userLoginInstance;
    final response = await dio.post(
      "$baseUrl/apple-login",
      data: {
        "code": code,
        "id_token": idToken,
        "email": email,
        "name": name,
      },
    );
    if (response.statusCode == 200) {
      userLoginInstance = UserLoginModel.fromJson(response.data);
      return userLoginInstance;
    }
    throw Error();
    // todo 에러 처리 추가해서 에러 화면으로 이동해야함
  }

  Future<Map<String, dynamic>> getUserData(
      String? accessToken, String? refreshToken) async {
    final response = await dio.get("$baseUrl/members",
        options: Options(headers: {
          "AccessToken": accessToken,
          "RefreshToken": refreshToken,
        }));
    if (response.statusCode == 200) {
      return response.data;
    }
    throw Error();
  }

  Future<void> withdrawal(String accessToken, String refreshToken,
      String withdrawalOptions, String content) async {
    final response = await dio.post(
      "$baseUrl/withdrawal",
      options: Options(headers: {
        "AccessToken": accessToken,
        "RefreshToken": refreshToken,
      }),
      data: {
        "withdrawalOptions": withdrawalOptions,
        "content": content,
      },
    );
    if (response.statusCode == 200) {
      print("탈퇴 성공 ~");
    }
  }
}
