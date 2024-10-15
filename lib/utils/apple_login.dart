import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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

  List<Map<String, String>> tokenData = [
    {'access_token': (response as UserLoginModel).accessToken},
    {'refresh_token': (response).refreshToken},
  ];
  writeStorage(tokenData);
  List<Map<String, String?>> userData = [
    {'email': credential.email},
    {'name': "${credential.givenName} ${credential.familyName}"},
    {'login_type': 'APPLE'},
  ];
  writeStorage(userData);
  if (response.isNew == true) {
    Get.offAllNamed(Routes.onBoarding);
  } else {
    Get.offAllNamed(Routes.home);
  }
  print(credential.email);
}
