import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:xive/main.dart';

class OnBoardingPageView extends StatelessWidget {
  final String title, content, imgPath;
  final bool isLastPage;

  const OnBoardingPageView({
    super.key,
    required this.controller,
    required this.title,
    required this.content,
    required this.imgPath,
    required this.isLastPage,
  });

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: lightModeTheme.textTheme.titleMedium,
          ),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xff636363),
              letterSpacing: -0.02,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Gif(
                  image: AssetImage(imgPath),
                  autostart: Autostart.once,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
