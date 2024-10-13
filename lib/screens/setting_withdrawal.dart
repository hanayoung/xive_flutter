import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/widgets/title_bar.dart';

class CheckboxController extends GetxController {
  var isChecked = false.obs; // 체크박스 상태를 RxBool로 관리

  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false; // 체크박스 상태 업데이트
  }
}

class SettingWithdrawal extends StatelessWidget {
  SettingWithdrawal({super.key});
  final CheckboxController controller = Get.put(CheckboxController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const TitleBar(
              title: "회원탈퇴",
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '정말 XIVE를 탈퇴하고 싶으신가요? 🥺',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      letterSpacing: -0.02,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text('회원 탈퇴 처리 내용',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(
                    height: 8,
                  ),
                  RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: '탈퇴하시면 개인정보 처리 방침에 따라 최대 30일 이내에 ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: '', // 사용자 맞춤형 텍스트
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: '님의 모든 개인정보 및 계정 정보가 삭제됩니다. 이후에는 ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: '', // 사용자 맞춤형 텍스트 반복
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: '님의 앱 내 활동 데이터는 다시 복구될 수 없습니다.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )),
                  CheckboxListTile(
                    value: controller.isChecked.value,
                    onChanged: (bool? value) {},
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    title: Align(
                      alignment: const Alignment(-1.3, 0),
                      child: Text(
                        '회원 탈퇴 처리 내용에 동의합니다.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
