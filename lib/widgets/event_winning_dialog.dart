import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xive/widgets/event_winning_item_dialog.dart';

class EventWinningDialog extends StatelessWidget {
  const EventWinningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.5,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SvgPicture.asset(
                          'assets/images/dialog_winning_gift.svg'),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '소여행에 오신 여러분, 환영합니다',
                          style: TextStyle(
                              letterSpacing: -0.02,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF393939)),
                        ),
                        Text(
                          '감사의 마음을 담아 선물을 준비했어요.\n지금 선물을 확인해보세요!',
                          style: TextStyle(
                              letterSpacing: -0.02,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF393939)),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          )),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              '선물 확인하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const EventWinningItemDialog(
                                  title: '2025 달력세트 당첨!',
                                  content: '2025 달력세트',
                                  imgPath:
                                      'assets/images/dialog_winning_calendar.svg');
                            });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
