import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:xive/controllers/splash_controller.dart';
import 'package:xive/models/user_login_model.dart';
import 'package:xive/routes/pages.dart';
import 'package:xive/services/user_service.dart';
import 'package:xive/utils/storage_write.dart';

appleLogin() async {
  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
  );
  print(
      "credential ${credential.email} ${credential.givenName}  ${credential.familyName}");
  dynamic response = await UserService().appleLogin(
      credential.authorizationCode,
      credential.identityToken!,
      credential.email!,
      "${credential.givenName} ${credential.familyName}");

  List<Map<String, String?>> data = [
    {'access_token': (response as UserLoginModel).accessToken},
    {'refresh_token': (response).refreshToken},
    {'email': credential.email},
    {'name': "${credential.givenName} ${credential.familyName}"},
    {'login_type': "APPLE"},
  ];
  await writeStorage(data);
  await SplashController.to.setData();

  if (response.isNew == true) {
    Get.offAllNamed(Routes.onBoarding);
  } else {
    Get.offAllNamed(Routes.home);
  }
  print(credential.email);
}

Future<bool> revokeSignInWithApple() async {
  try {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final String authCode = appleCredential.authorizationCode;

    final String privateKey = [
      dotenv.env['APPLE_PRIVATE_KEY_LINE1']!,
      dotenv.env['APPLE_PRIVATE_KEY_LINE2']!,
      dotenv.env['APPLE_PRIVATE_KEY_LINE3']!,
      dotenv.env['APPLE_PRIVATE_KEY_LINE4']!,
      dotenv.env['APPLE_PRIVATE_KEY_LINE5']!,
      dotenv.env['APPLE_PRIVATE_KEY_LINE6']!,
    ].join('\r');

    print("privateKey $privateKey");
    final teamId = dotenv.env['APPLE_TEAM_ID'];
    final clientId = dotenv.env['APPLE_BUNDLE_ID'];
    final keyId = dotenv.env['APPLE_KEY_ID'];

    final String clientSecret = createJwt(
      teamId: teamId!,
      clientId: clientId!,
      keyId: keyId!,
      privateKey: privateKey,
    );

    final accessToken = (await requestAppleTokens(
      authCode,
      clientSecret,
      clientId,
    ))['access_token'] as String;
    print("accessToken $accessToken");
    const String tokenTypeHint = 'access_token';

    await revokeAppleToken(
      clientId: clientId,
      clientSecret: clientSecret,
      token: accessToken,
      tokenTypeHint: tokenTypeHint,
    );

    return true;
  } on Exception catch (e) {
    print(e.toString());
    return false;
  }
}

String createJwt({
  required String teamId,
  required String clientId,
  required String keyId,
  required String privateKey,
}) {
  final jwt = JWT(
    {
      'iss': teamId,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600,
      'aud': 'https://appleid.apple.com',
      'sub': clientId,
    },
    header: {
      'kid': keyId,
      'alg': 'ES256',
    },
  );
  print("createJWT $jwt");
  final key = ECPrivateKey(privateKey);
  print("createJWT key $key");
  return jwt.sign(key, algorithm: JWTAlgorithm.ES256);
}

// 사용자 토큰 취소 함수
Future<bool> revokeAppleToken({
  required String clientId,
  required String clientSecret,
  required String token,
  required String tokenTypeHint,
}) async {
  try {
    const url = 'https://appleid.apple.com/auth/revoke';
    final response = await Dio().post(
      url,
      options: Options(headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }),
      data: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'token': token,
        'token_type_hint': tokenTypeHint,
      },
    );

    if (response.statusCode == 200) {
      // 토큰이 성공적으로 취소됨
      print("revokeAppleToken ${response.data}");
      return true;
    } else {
      print("revokeAppleToken response statusCode ${response.statusMessage}");
      return false;
    }
  } on Exception catch (e) {
    print("revokeAppleToken fail ${e.toString()}");
    return false;
  }
}

Future<Map<String, dynamic>> requestAppleTokens(
  String authorizationCode,
  String clientSecret,
  String clientId,
) async {
  final response = await Dio().post(
    "https://appleid.apple.com/auth/token",
    options: Options(headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    }),
    data: {
      'client_id': clientId,
      'client_secret': clientSecret,
      'code': authorizationCode,
      'grant_type': 'authorization_code',
    },
  );

  if (response.statusCode == 200) {
    print("requestAppleToken ${response.data}");
    return response.data;
  } else {
    throw Exception('토큰 요청 실패: ${response.data}');
  }
}

// class Failure {
//   final String message;
//   Failure(this.message);
// }
