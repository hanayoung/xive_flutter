import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/splash_controller.dart';
import 'package:xive/main.dart';
import 'package:xive/services/contact_service.dart';
import 'package:xive/utils/storage_write.dart';
import 'package:xive/widgets/title_bar.dart';

class ContactController extends GetxController {
  var email = ''.obs;
  var content = ''.obs;
}

class SettingContactScreen extends StatelessWidget {
  SettingContactScreen({super.key});
  final ContactController controller = Get.put(ContactController());
  dynamic accessToken, refreshToken;
  _contact() async {
    accessToken = await storage.read(key: 'access_token') ?? "";
    refreshToken = await storage.read(key: 'refresh_token') ?? "";
    bool result = await ContactService().contact(accessToken, refreshToken,
        controller.email.value, controller.content.value);
    if (result) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode emailFocus = FocusNode();
    FocusNode contentFocus = FocusNode();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: GestureDetector(
          onTap: () {
            emailFocus.unfocus();
            contentFocus.unfocus();
          },
          child: LayoutBuilder(builder: (context, constraints) {
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
                              title: "1:1문의",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      '답변받으실 이메일',
                                      style:
                                          lightModeTheme.textTheme.titleSmall,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      style: lightModeTheme.textTheme.bodySmall,
                                      onChanged: (value) {
                                        controller.email.value = value;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      focusNode: emailFocus,
                                      decoration: InputDecoration(
                                        hintText: 'email@example.com',
                                        hintStyle:
                                            lightModeTheme.textTheme.labelSmall,
                                        contentPadding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        isDense: true,
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xFFBCB5C2),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: lightModeTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Obx(() =>
                                        (controller.email.value.isNotEmpty &&
                                                !GetUtils.isEmail(
                                                    controller.email.value))
                                            ? const Text(
                                                '올바르지 않은 이메일 형식입니다.',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFFF5352),
                                                  letterSpacing: -0.02,
                                                ),
                                              )
                                            : Container()),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '문의 내용',
                                          style: lightModeTheme
                                              .textTheme.titleSmall,
                                        ),
                                        Obx(
                                          () => Text(
                                            '${controller.content.value.length}/500',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              letterSpacing: -0.02,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      style: lightModeTheme.textTheme.bodySmall,
                                      onChanged: (value) {
                                        controller.content.value = value;
                                      },
                                      keyboardType: TextInputType.multiline,
                                      focusNode: contentFocus,
                                      maxLength: 500,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: '최대 500자까지 입력 가능합니다.',
                                        hintStyle:
                                            lightModeTheme.textTheme.labelSmall,
                                        // errorText: '올바른 이메일 형식이 아닙니다.',
                                        counterText: "",
                                        contentPadding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        isDense: true,
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xFFBCB5C2),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: lightModeTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            const Spacer(),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Obx(
                                        () => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 40),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor: (controller.email
                                                          .value.isNotEmpty &&
                                                      GetUtils.isEmail(
                                                          controller
                                                              .email.value) &&
                                                      controller.content.value
                                                          .isNotEmpty)
                                                  ? Colors.black
                                                  : const Color(0xFFDFDFDF),
                                            ),
                                            onPressed: (controller.email.value
                                                        .isNotEmpty &&
                                                    GetUtils.isEmail(controller
                                                        .email.value) &&
                                                    controller.content.value
                                                        .isNotEmpty)
                                                ? () => _contact()
                                                : null,
                                            child: Text(
                                              '문의하기',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  letterSpacing: -0.02,
                                                  color: (controller.email.value
                                                              .isNotEmpty &&
                                                          GetUtils.isEmail(
                                                              controller.email
                                                                  .value) &&
                                                          controller.content
                                                              .value.isNotEmpty)
                                                      ? Colors.white
                                                      : const Color(
                                                          0xff9e9e9e)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        )));
  }
}
