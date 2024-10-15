import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class DioInterceptor implements InterceptorsWrapper {

  var dio = Dio();
  final storage = FlutterSecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    final accessToken = await storage.read(key: 'access_token');
    final refreshToken = await storage.read(key: 'refresh_token');

    options.headers["AccessToken"] = accessToken;
    options.headers["RefreshToken"] = refreshToken;

    return handler.next(options);

  }

  @override
  void onResponse(response, ResponseInterceptorHandler handler) async {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }



}
