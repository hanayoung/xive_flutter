import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xive/main.dart';
import 'package:xive/services/user_service.dart';
import 'package:xive/widgets/setting_dialog.dart';
import 'package:xive/widgets/setting_divider.dart';
import 'package:xive/widgets/title_bar.dart';

import '../routes/pages.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  static const storage = FlutterSecureStorage();
  Future<(String, String)> _getUserData() async {
    var accessToken = await storage.read(key: 'access_token');
    var refreshToken = await storage.read(key: 'refresh_token');
    print("getUserData accesToken $accessToken refreshToken $refreshToken");
    Map<String, dynamic>? userData =
        await UserService().getUserData(accessToken, refreshToken);
    String loginType = userData['loginType'] ?? "";
    String name = userData['nickname'] ?? "";
    // controller.name.value = name;
    // controller.loginType.value = loginType;
    await storage.write(key: 'login_type', value: loginType);
    print("loginType $loginType name $name");
    // await storage.write(key: 'email', value: email);
    return (name, loginType);
  }

  Future<(String, String?, String)> _loadLoginData() async {
    // null이면 서버요청
    var name = await storage.read(key: 'name') ?? "";
    var email = await storage.read(key: 'email');
    var loginType = await storage.read(key: 'login_type');
    if (email == null || loginType == null) {
      print("email and logintype null");
      final (fName, fLoginType) = await _getUserData();
      return (fName, email, fLoginType);
    } else {
      return (name, email, loginType);
    }
  }

  Future<PackageInfo> _loadPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  logout(BuildContext context) async {
    Navigator.pop(context);
    await storage.deleteAll();
    Get.offAllNamed(Routes.splash);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
            future: _loadLoginData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return Container();
              } else {
                final (name, email, loginType) = snapshot.data!;
                return Column(
                  children: [
                    const TitleBar(
                      title: "설정",
                    ),
                    const SettingDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 56,
                                child: Center(
                                  child: Text(
                                    '로그인 계정',
                                    style: lightModeTheme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Row(
                                children: [
                                  loginType == "KAKAO"
                                      ? SvgPicture.asset(
                                          'assets/images/kakao_small_icon.svg',
                                        )
                                      : SvgPicture.asset(
                                          'assets/images/apple_small_icon.svg',
                                        ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 200,
                                    ),
                                    child: Text(
                                      email ?? name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: lightModeTheme.textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Platform.isIOS
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 56,
                                      child: Center(
                                        child: Text(
                                          '애플 계정 연동하기',
                                          style: loginType == "APPLE"
                                              ? lightModeTheme
                                                  .textTheme.bodyMedium
                                              : const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF9E9E9E),
                                                  letterSpacing: -0.02,
                                                ),
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      loginType == "APPLE"
                                          ? 'assets/images/setting_toggle_btn.svg'
                                          : 'assets/images/setting_toggle_off_btn.svg',
                                    ),
                                  ],
                                )
                              : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 56,
                                child: Center(
                                  child: Text(
                                    '카카오 계정 연동하기',
                                    style: lightModeTheme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                loginType == "KAKAO"
                                    ? 'assets/images/setting_toggle_btn.svg'
                                    : 'assets/images/setting_toggle_off_btn.svg',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SettingDivider(),
                    InkWell(
                      onTap: () => Get.toNamed(Routes.contact),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 56,
                              child: Center(
                                child: Text(
                                  '1:1 문의',
                                  style: lightModeTheme.textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/images/right_arrow_icon.svg',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SettingDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () => Get.toNamed(Routes.terms),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 56,
                                  child: Center(
                                    child: Text(
                                      '서비스 이용 약관',
                                      style:
                                          lightModeTheme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/images/right_arrow_icon.svg',
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => Get.toNamed(Routes.pp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 56,
                                  child: Center(
                                    child: Text(
                                      '개인정보 처리 방침',
                                      style:
                                          lightModeTheme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/images/right_arrow_icon.svg',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SettingDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 56,
                            child: Center(
                              child: Text(
                                '버전 정보',
                                style: lightModeTheme.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          FutureBuilder<PackageInfo>(
                              future: _loadPackageInfo(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<PackageInfo> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!.version,
                                    style: lightModeTheme.textTheme.bodyMedium,
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),
                        ],
                      ),
                    ),
                    const SettingDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SettingDialog(
                                          func: logout,
                                        );
                                      });
                                },
                                child: const SizedBox(
                                  height: 56,
                                  child: Center(
                                    child: Text(
                                      '로그아웃',
                                      style: TextStyle(
                                        color: Color(0xff9e9e9e),
                                        fontSize: 16,
                                        letterSpacing: -0.02,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Get.toNamed(Routes.withdrawal),
                            child: const Row(
                              children: [
                                SizedBox(
                                  height: 56,
                                  child: Center(
                                    child: Text(
                                      '회원탈퇴',
                                      style: TextStyle(
                                        color: Color(0xff9e9e9e),
                                        fontSize: 16,
                                        letterSpacing: -0.02,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
