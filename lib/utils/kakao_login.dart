import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:xive/models/user_login_model.dart';
import 'package:xive/routes/pages.dart';
import 'package:xive/services/user_service.dart';
import 'package:xive/utils/storage_write.dart';

kakaoSignUp(BuildContext context) async {
  // 카카오톡 실행 가능 여부 확인
  // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
  if (await isKakaoTalkInstalled()) {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      dynamic response = await UserService().kakaoLogin(token.accessToken);
      List<Map<String, String>> tokenData = [
        {'access_token': (response as UserLoginModel).accessToken},
        {'refresh_token': (response).refreshToken},
      ];
      writeStorage(tokenData);

      User user = await UserApi.instance.me();

      List<Map<String, String?>> userData = [
        {'email': user.kakaoAccount?.email},
        {'name': user.kakaoAccount?.profile?.nickname},
        {'login_type': 'KAKAO'},
      ];
      writeStorage(userData);

      if (response.isNew == true) {
        Get.offAllNamed(Routes.onBoarding);
      } else {
        Get.offAllNamed(Routes.home);
      }
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        dynamic response = await UserService().kakaoLogin(token.accessToken);
        List<Map<String, String>> tokenData = [
          {'access_token': (response as UserLoginModel).accessToken},
          {'refresh_token': (response).refreshToken},
        ];
        writeStorage(tokenData);

        User user = await UserApi.instance.me();

        List<Map<String, String?>> userData = [
          {'email': user.kakaoAccount?.email},
          {'name': user.kakaoAccount?.profile?.nickname},
          {'login_type': 'KAKAO'},
        ];
        writeStorage(userData);
        if (response.isNew == true) {
          Get.offAllNamed(Routes.onBoarding);
        } else {
          Get.offAllNamed(Routes.home);
        }
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  } else {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      dynamic response = await UserService().kakaoLogin(token.accessToken);
      List<Map<String, String>> tokenData = [
        {'access_token': (response as UserLoginModel).accessToken},
        {'refresh_token': (response).refreshToken},
      ];
      writeStorage(tokenData);

      User user = await UserApi.instance.me();

      List<Map<String, String?>> userData = [
        {'email': user.kakaoAccount?.email},
        {'name': user.kakaoAccount?.profile?.nickname},
        {'login_type': 'KAKAO'},
      ];
      writeStorage(userData);
      if (response.isNew == true) {
        Get.offAllNamed(Routes.onBoarding);
      } else {
        Get.offAllNamed(Routes.home);
      }
      // 이게 진짜 코드
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}
