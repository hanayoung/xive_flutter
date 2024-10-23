import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xive/services/dio_interceptor.dart';

class ContactService {
  final dio = Dio();
  final baseUrl = dotenv.env['BASE_URL'];
  final dioInterceptor = DioInterceptor();
  ContactService._privateConstructor();

  static final ContactService _instance = ContactService._privateConstructor();

  factory ContactService() {
    return _instance;
  }
  Future<bool> contact(String accessToken, String refreshToken, String email,
      String contents) async {
    dio.interceptors.clear();
    dio.interceptors.add(dioInterceptor);
    final response = await dio.post(
      "$baseUrl/inquiries",
      data: {
        "email": email,
        "contents": contents,
      },
    );
    if (response.statusCode == 200) {
      print("문의넣기 성공");
      return true;
    }
    throw Error();
    // todo 에러 처리 추가해서 에러 화면으로 이동해야함
  }
}
