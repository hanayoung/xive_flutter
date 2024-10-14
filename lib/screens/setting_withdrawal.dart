import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/splash_controller.dart';
import 'package:xive/widgets/custom_check_box.dart';
import 'package:xive/widgets/title_bar.dart';

class SettingController extends GetxController {
  var isChecked = false.obs;
  var selectedIdx = (-1).obs;
  var isBtnEnabled = false.obs;

  void toggleCheckbox() {
    isChecked.value = !isChecked.value; // 체크박스 상태 업데이트
    if (isChecked.value == false) {
      isBtnEnabled.value = false;
      selectedIdx.value = -1;
    }
  }

  void setSelectedIdx(int idx) {
    if (selectedIdx.value == idx) {
      selectedIdx.value = (-1);
      isBtnEnabled.value = false;
    } else {
      selectedIdx.value = idx;
      isBtnEnabled.value = true;
    }
  }
}

class SettingWithdrawal extends StatelessWidget {
  SettingWithdrawal({super.key});
  final SettingController controller = Get.put(SettingController());
  final SplashController viewModel = SplashController.to;
  final List<String> reasons = [
    'XIVE에서 제공하는 티켓에 불만족함',
    '자주 사용하지 않음',
    '앱 사용 방식이 어려움',
    '잦은 오류와 장애가 발생함',
    '다른 계정으로 재가입하기 위함',
    '기타',
  ];
  @override
  Widget build(BuildContext context) {
    FocusNode textFocus = FocusNode();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => textFocus.unfocus(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const TitleBar(
                        title: "회원탈퇴",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 16.0),
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
                                  text:
                                      '${viewModel.name.value}', // 사용자 맞춤형 텍스트
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: '님의 모든 개인정보 및 계정 정보가 삭제됩니다. 이후에는 ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text:
                                      '${viewModel.name.value}', // 사용자 맞춤형 텍스트 반복
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: '님의 앱 내 활동 데이터는 다시 복구될 수 없습니다.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            )),
                            const SizedBox(
                              height: 16,
                            ),
                            InkWell(
                              onTap: () => controller.toggleCheckbox(),
                              child: Row(
                                children: [
                                  CustomCheckBox(
                                    controller: controller,
                                    isMain: true,
                                    idx: 0,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    '회원 탈퇴 처리 내용에 동의합니다.',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Obx(() {
                                  if (controller.isChecked.value == true) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Text(
                                          'XIVE 서비스를 그만 사용하는 이유를 알려주세요!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '이후 더 나은 서비스로 찾아뵙겠습니다.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: reasons.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () => controller
                                                  .setSelectedIdx(index),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                child: Row(
                                                  children: [
                                                    CustomCheckBox(
                                                      controller: controller,
                                                      isMain: false,
                                                      idx: index,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      reasons[index],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        controller.selectedIdx.value == 5
                                            ? TextField(
                                                keyboardType:
                                                    TextInputType.text,
                                                focusNode: textFocus,
                                                cursorColor:
                                                    const Color(0xff767676),
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            '계정을 삭제하려는 이유를 알려주세요.',
                                                        fillColor:
                                                            Color(0xFFF4F4F4),
                                                        filled: true,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        hintStyle: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: -0.02,
                                                          color:
                                                              Color(0xff767676),
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        )),
                                              )
                                            : Container()
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Obx(
                              () => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: controller.isBtnEnabled.value
                                      ? Colors.black
                                      : const Color(0xFFDFDFDF),
                                ),
                                onPressed: controller.isBtnEnabled.value
                                    ? () {}
                                    : () {},
                                child: Text(
                                  '탈퇴하기',
                                  style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: -0.02,
                                      color: controller.isBtnEnabled.value
                                          ? Colors.white
                                          : const Color(0xff9e9e9e)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
