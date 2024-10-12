import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xive/utils/apple_login.dart';
import 'package:xive/widgets/setting_divider.dart';
import 'package:xive/widgets/title_bar.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  static const storage = FlutterSecureStorage();
  dynamic loginType = '';
  dynamic email = '';
  dynamic packageInfo = '';

  Future<void> _loadLoginData() async {
    loginType = await storage.read(key: 'login_type');
    // null이면 서버요청
    email = await storage.read(key: 'email');
    email ??= await storage.read(key: 'name');
    // null이면 서버요청
    packageInfo = await PackageInfo.fromPlatform();
  }

  void logout(BuildContext context) async {
    Navigator.pushNamedAndRemoveUntil(context, '/signup', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
            future: _loadLoginData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  loginType == "kakao"
                                      ? SvgPicture.asset(
                                          'assets/images/kakao_small_icon.svg',
                                        )
                                      : SvgPicture.asset(
                                          'assets/images/apple_small_icon.svg',
                                        ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    email,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                                          style: loginType == "apple"
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                              : const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF9E9E9E),
                                                  letterSpacing: -0.02,
                                                ),
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      loginType == "apple"
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/images/setting_toggle_btn.svg',
                              ),
                            ],
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
                                '1:1 문의',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/images/right_arrow_icon.svg',
                          ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 56,
                                child: Center(
                                  child: Text(
                                    '서비스 이용 약관',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/images/right_arrow_icon.svg',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 56,
                                child: Center(
                                  child: Text(
                                    '개인정보 처리 방침',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/images/right_arrow_icon.svg',
                              ),
                            ],
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          Text(
                            packageInfo.version,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
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
                              GestureDetector(
                                onTap: () {
                                  logout(context);
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
                          const Row(
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
