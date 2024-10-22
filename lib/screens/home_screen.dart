import 'dart:io';

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
      body: Stack(
        children: [
          // Background image using Obx
          Obx(() {
            return Container(
              decoration: controller.bgImgUrl.value.isNotEmpty
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(controller.bgImgUrl.value),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0, -0.2),
                        radius: 0.5,
                        colors: [
                          Color(0xFFB5B5B5),
                          Color(0xFFFFFFFF),
                        ],
                        stops: [0.2, 1.0],
                      ),
                    ),
              child: controller.ticketList.isNotEmpty
                  ? HomeTicket()
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/home_no_card_img.png',
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 60),
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
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
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
          // Top SafeArea (white)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).padding.top,
            ),
          ),
          // SafeArea for content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.white,
                  padding: Platform.isIOS
                      ? const EdgeInsets.only(bottom: 10, left: 24, right: 24)
                      : const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Get.toNamed(Routes.setting),
                        child: SvgPicture.asset(
                          'assets/images/home_setting_icon.svg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(Routes.audio),
                        child: Image.asset(
                          'assets/images/audio_icon.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/images/home_xive_icon.svg',
                        height: 12,
                        width: 48,
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(Routes.calendar),
                        child: SvgPicture.asset(
                            'assets/images/home_calendar_icon.svg',
                            height: 24,
                            width: 24),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
