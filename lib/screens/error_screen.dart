import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:xive/main.dart';
import 'package:xive/routes/pages.dart';
import 'package:xive/utils/storage_write.dart';
import 'package:xive/widgets/title_bar.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  void reTry() async {
    await storage.deleteAll();
    Get.offAllNamed(Routes.signUp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        const TitleBar(title: ""),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/error_icon.svg"),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  '현재 접속이 원활하지 않아요.',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: -0.02,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  '일시적인 오류로 서비스에 접속할 수 없습니다.\n잠시 후 다시 시도해 주세요.',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: -0.02,
                    color: Color(0xFF9E9E9E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 56,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () => reTry(),
                        child: const Text(
                          '홈으로 돌아가기',
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: -0.02,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () => reTry(),
                  child: Text(
                    '다시 시도',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      letterSpacing: -0.02,
                      color: lightModeTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    )));
  }
}
