import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:xive/main.dart';
import 'package:xive/routes/pages.dart';
import 'package:xive/services/user_service.dart';
import 'package:xive/utils/apple_login.dart';
import 'package:xive/widgets/custom_check_box.dart';
import 'package:xive/widgets/title_bar.dart';

class WithDrawalController extends GetxController {
  var isChecked = false;
  var selectedIdx = (-1);
  var isBtnEnabled = false;

  var accessToken = "";
  var refreshToken = "";
  var name = "";
  var loginType = "";

  Future<void> loadData() async {
    const storage = FlutterSecureStorage();
    accessToken = await storage.read(key: 'access_token') ?? "";
    refreshToken = await storage.read(key: 'refresh_token') ?? "";
    name = await storage.read(key: 'name') ?? "";
    loginType = await storage.read(key: 'login_type') ?? "";
    print("name $name");
  }

  void toggleCheckbox() {
    isChecked = !isChecked; // 체크박스 상태 업데이트
    if (isChecked == false) {
      isBtnEnabled = false;
      selectedIdx = -1;
    }
    update();
  }

  void setSelectedIdx(int idx) {
    if (selectedIdx == idx) {
      selectedIdx = (-1);
      isBtnEnabled = false;
    } else {
      if (idx < 5) {
        selectedIdx = idx;
        isBtnEnabled = true;
      } else {
        selectedIdx = idx;
        isBtnEnabled = false;
      }
    }
    update();
  }

  void updateBtnState(String value) {
    if (selectedIdx == 5) {
      isBtnEnabled = value.isNotEmpty;
    }
    update();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadData();
  // }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    loadData();
  }

  @override
  void onClose() {
    // 여기서 값들을 초기화
    isChecked = false;
    selectedIdx = -1;
    name = "";
    isBtnEnabled = false;
    super.onClose();
  }
}

class SettingWithdrawal extends StatelessWidget {
  final WithDrawalController controller = Get.put(WithDrawalController());
  final TextEditingController textController = TextEditingController();
  static const storage = FlutterSecureStorage();
  SettingWithdrawal({super.key}) {
    textController.addListener(() {
      controller.updateBtnState(textController.text);
    });
  }

  final List<String> reasons = [
    'XIVE에서 제공하는 티켓에 불만족함',
    '자주 사용하지 않음',
    '앱 사용 방식이 어려움',
    '잦은 오류와 장애가 발생함',
    '다른 계정으로 재가입하기 위함',
    '기타',
  ];

  _withdrawal(String? content) async {
    if (controller.selectedIdx < 5) {
      content = "NONE";
    }
    bool result = await UserService().withdrawal(
        controller.accessToken,
        controller.refreshToken,
        controller.selectedIdx < 5
            ? "OPTION${(controller.selectedIdx) + 1}"
            : "OTHER_OPTION",
        content!);
    if (result) {
      if (controller.loginType == "APPLE") {
        print("revoke Apple Token");
        await revokeSignInWithApple();
      }
      await storage.deleteAll();
      Get.delete<WithDrawalController>();
      Get.offAllNamed(Routes.splash);
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode textFocus = FocusNode();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => textFocus.unfocus(),
          child: LayoutBuilder(builder: (context, constraints) {
            return GetBuilder<WithDrawalController>(
              autoRemove: true,
              init: WithDrawalController(),
              builder: (controller) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                const TitleBar(
                                  title: "회원탈퇴",
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const SizedBox(height: 16),
                                      Text('회원 탈퇴 처리 내용',
                                          style: lightModeTheme
                                              .textTheme.titleSmall),
                                      const SizedBox(height: 8),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '탈퇴하시면 개인정보 처리 방침에 따라 최대 30일 이내에 ',
                                              style: lightModeTheme
                                                  .textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: controller.name,
                                              style: lightModeTheme
                                                  .textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text:
                                                  '님의 모든 개인정보 및 계정 정보가 삭제됩니다. 이후에는 ',
                                              style: lightModeTheme
                                                  .textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text: controller.name,
                                              style: lightModeTheme
                                                  .textTheme.bodySmall,
                                            ),
                                            TextSpan(
                                              text:
                                                  '님의 앱 내 활동 데이터는 다시 복구될 수 없습니다.',
                                              style: lightModeTheme
                                                  .textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      InkWell(
                                        onTap: () =>
                                            controller.toggleCheckbox(),
                                        child: Row(
                                          children: [
                                            const CustomCheckBox(
                                              isMain: true,
                                              idx: 0,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              '회원 탈퇴 처리 내용에 동의합니다.',
                                              style: lightModeTheme
                                                  .textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (controller.isChecked)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 40),
                                            Text(
                                              'XIVE 서비스를 그만 사용하는 이유를 알려주세요!',
                                              style: lightModeTheme
                                                  .textTheme.titleSmall,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '이후 더 나은 서비스로 찾아뵙겠습니다.',
                                              style: lightModeTheme
                                                  .textTheme.bodySmall,
                                            ),
                                            Column(
                                              children: List<Widget>.generate(
                                                reasons.length,
                                                (index) {
                                                  return InkWell(
                                                    onTap: () => controller
                                                        .setSelectedIdx(index),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                      child: Row(
                                                        children: [
                                                          CustomCheckBox(
                                                            isMain: false,
                                                            idx: index,
                                                          ),
                                                          const SizedBox(
                                                              width: 12),
                                                          Text(
                                                            reasons[index],
                                                            style:
                                                                lightModeTheme
                                                                    .textTheme
                                                                    .bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            if (controller.selectedIdx == 5)
                                              TextField(
                                                controller: textController,
                                                keyboardType:
                                                    TextInputType.text,
                                                focusNode: textFocus,
                                                cursorColor:
                                                    const Color(0xff767676),
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      '계정을 삭제하려는 이유를 알려주세요.',
                                                  fillColor: Color(0xFFF4F4F4),
                                                  filled: true,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    letterSpacing: -0.02,
                                                    color: Color(0xff767676),
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                onSubmitted: (value) {
                                                  if (controller.isBtnEnabled) {
                                                    _withdrawal(value);
                                                  }
                                                },
                                              ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 40),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor:
                                                controller.isBtnEnabled
                                                    ? Colors.black
                                                    : const Color(0xFFDFDFDF),
                                          ),
                                          onPressed: controller.isBtnEnabled
                                              ? () => _withdrawal(
                                                  textController.text)
                                              : null,
                                          child: Text(
                                            '탈퇴하기',
                                            style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: -0.02,
                                              color: controller.isBtnEnabled
                                                  ? Colors.white
                                                  : const Color(0xff9e9e9e),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
