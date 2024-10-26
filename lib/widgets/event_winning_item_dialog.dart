import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EventWinningItemDialog extends StatelessWidget {
  final String title, content, imgPath;
  const EventWinningItemDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.imgPath});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF393939),
                fontWeight: FontWeight.w700,
                letterSpacing: -0.02,
              ),
            ),
            SvgPicture.asset(imgPath),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: '전시 관람 후 1층 인포에서\n',
                style: const TextStyle(
                  color: Color(0xFF323232),
                  fontSize: 18,
                  letterSpacing: -0.02,
                  fontWeight: FontWeight.w400,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: content,
                    style: const TextStyle(
                      color: Color(0xFF323232),
                      fontSize: 18,
                      letterSpacing: -0.02,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text: '를 수령해주세요',
                    style: TextStyle(
                      color: Color(0xFF323232),
                      fontSize: 18,
                      letterSpacing: -0.02,
                      fontWeight: FontWeight.w400,
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
