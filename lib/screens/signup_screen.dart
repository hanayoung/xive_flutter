import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xive/utils/apple_login.dart';
import 'package:xive/utils/kakao_login.dart';
import 'package:xive/widgets/long_icon_btn.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/login_logo.svg",
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    const LongIconBtn(
                      text: '카카오로 시작하기',
                      imgPath: "assets/images/login_kakao_icon.svg",
                      backgroundColor: 0xfffee500,
                      isApple: false,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Platform.isIOS
                        ? const LongIconBtn(
                            text: 'Apple로 시작하기',
                            imgPath: "assets/images/apple_small_icon.svg",
                            backgroundColor: 0xffffffff,
                            isApple: true,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
