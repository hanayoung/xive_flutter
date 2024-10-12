import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xive/models/user_login_model.dart';

class UserService {
  final dio = Dio();
  final baseUrl = dotenv.env['BASE_URL'];

  Future<UserLoginModel> login(String accessToken) async {
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
}
