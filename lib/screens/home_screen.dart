import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/ticket_controller.dart';
import 'package:xive/widgets/home_ticket.dart';

import '../routes/pages.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TicketController controller = TicketController.to;
  @override
  Widget build(BuildContext context) {
    controller.buildContext = context;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.toNamed(Routes.setting),
                    child: SvgPicture.asset(
                      'assets/images/home_setting_icon.svg',
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.toNamed(Routes.audio),
                    child: Image.asset(
                      'assets/images/audio_icon.png',
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/home_xive_icon.svg',
                  ),
                  InkWell(
                    onTap: () => Get.toNamed(Routes.calendar),
                    child: SvgPicture.asset(
                      'assets/images/home_calendar_icon.svg',
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              return controller.ticketList.isNotEmpty
                  ? Expanded(
                      child: Container(
                      decoration: controller.bgImgUrl.value.isNotEmpty
                          ? BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(controller.bgImgUrl.value),
                                fit: BoxFit.fill,
                              ),
                            )
                          : null,
                      child: HomeTicket(),
                    ))
                  : Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(0, -0.2), // 그라데이션의 중심
                            radius: 0.5, // 그라데이션의 반경
                            colors: [
                              Color(0xFFB5B5B5), // 중간이 진한 색상
                              Color(0xFFFFFFFF), // 위아래로 갈수록 연한 색상
                            ],
                            stops: [
                              0.2,
                              1.0
                            ], // 색상이 변화하는 지점 (0.5 = 중간, 1.0 = 끝)
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/home_no_card_img.png',
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            const Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                  text: 'Add +\n',
                                  style: TextStyle(
                                    color: Color(0xFF8000FF),
                                    fontSize: 32,
                                    letterSpacing: -0.02,
                                    fontWeight: FontWeight.w600,
                                    height: 26 / 32,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Smart ticket',
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 32,
                                        letterSpacing: -0.02,
                                        fontWeight: FontWeight.w600,
                                        height: 26 / 32,
                                      ),
                                    )
                                  ]),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              '스마트 티켓을 등록해주세요',
                              style: TextStyle(
                                color: Color(0xFF636363),
                                fontSize: 16,
                                letterSpacing: -0.02,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
      floatingActionButton: Transform.scale(
        scale: 1.3,
        child: FloatingActionButton(
          onPressed: () => controller.readNfc(),
          elevation: 0,
          shape: const CircleBorder(),
          backgroundColor: Colors.white.withOpacity(0),
          child: Image.asset(
            'assets/images/home_nfc_icon_black.png',
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
