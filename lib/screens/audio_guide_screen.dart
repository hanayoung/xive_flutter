import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/main.dart';
import 'package:xive/models/ticket_model.dart';
import 'package:xive/routes/pages.dart';
import 'package:xive/services/ticket_service.dart';
import 'package:xive/widgets/event_winning_dialog.dart';
import 'package:xive/widgets/title_bar.dart';

class AudioGuideScreen extends StatelessWidget {
  const AudioGuideScreen({super.key});

  _getIsWinning(TicketModel? ticket) async {
    bool result = false;
    if (ticket != null) {
      result = await TicketService().getWinningStatus(ticket.ticketId);
    }
    return result;
  }

  Future<void> _showWinningDialog(
      BuildContext context, TicketModel? ticket) async {
    bool result = await _getIsWinning(ticket);
    if (result == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const EventWinningDialog();
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TicketModel? ticket = Get.arguments;
    return FutureBuilder(
        future: _showWinningDialog(context, ticket),
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
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
                                      title: '소여행: 10 miles away from home'),
                                  Image.asset(
                                      'assets/images/audio_guide_img.png'),
                                  Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 80,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: lightModeTheme.primaryColor
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '진행중',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  lightModeTheme.primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        const Text(
                                          '소여행: 10 miles away from home',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        const Row(
                                          children: [
                                            SizedBox(
                                              width: 40,
                                              child: Text(
                                                '장소',
                                                style: TextStyle(
                                                  color: Color(0xFF636363),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '망원 구피',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        const Row(
                                          children: [
                                            SizedBox(
                                              width: 40,
                                              child: Text(
                                                '기간',
                                                style: TextStyle(
                                                  color: Color(0xFF636363),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '2024.11.01 ~ 2024.11.03',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: lightModeTheme.dividerColor,
                                    height: 2,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 28,
                                    ),
                                    child: Text(
                                      '제주에 사는 사진 작가 제이시의 사진전 〈소여행)을 서울 도심에서 만나보세요. 바다가 보이는 곳에서 매일 여행하듯이, 살고 싶은 곳에서 살아가는 그녀와 함께 일상 속 행복을 느껴보세요.',
                                      style:
                                          lightModeTheme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 24.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () => Get.toNamed(Routes.audio),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: const Text(
                                    '오디오 가이드 듣기',
                                    style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: -0.02,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ));
        });
  }
}
