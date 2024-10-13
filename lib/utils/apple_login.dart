import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

appleLogin() async {
  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
  );
  print(credential.email);
}
