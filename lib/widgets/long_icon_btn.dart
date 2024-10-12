import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xive/utils/kakao_login.dart';

class LongIconBtn extends StatelessWidget {
  final String text, imgPath;
  final int backgroundColor;
  const LongIconBtn({
    super.key,
    required this.text,
    required this.imgPath,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(backgroundColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  )),
              onPressed: () async {
                await kakaoSignUp(context);
                // 여기서 분기처리해야할듯?
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    imgPath,
                    width: 20,
                    height: 20,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
