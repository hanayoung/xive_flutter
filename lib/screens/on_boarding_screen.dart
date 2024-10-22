import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xive/main.dart';
import 'package:xive/widgets/on_boarding_page_view.dart';
import 'package:xive/widgets/page_view_long_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OnBoardingSceenState();
}

class _OnBoardingSceenState extends State<OnBoardingScreen> {
  var isLastPage = false;
  final PageController controller =
      PageController(initialPage: 0, viewportFraction: 1);
  var currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Column(
          children: [
            Opacity(
              opacity: isLastPage ? 0.0 : 1.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        overlayColor: WidgetStateColor.resolveWith(
                            (states) => Colors.transparent),
                        padding: const EdgeInsets.all(0),
                      ),
                      onPressed: () {
                        controller.jumpToPage(2);
                      },
                      child: const Text(
                        '건너뛰기',
                        style: TextStyle(
                          letterSpacing: -0.02,
                          fontSize: 16,
                          color: Color(0xff9e9e9e),
                        ),
                      )),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.68,
              padding: const EdgeInsets.all(0.0),
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: controller,
                onPageChanged: (value) {
                  if (value == 2) {
                    setState(() {
                      isLastPage = true;
                      currentPage = value;
                    });
                  } else {
                    setState(() {
                      isLastPage = false;
                      currentPage = value;
                    });
                  }
                },
                children: [
                  OnBoardingPageView(
                    controller: controller,
                    title: "스마트 티켓을 태깅해보세요",
                    content: "스마트 티켓은 NFC 태깅이 가능한\n카이브만의 서비스예요",
                    imgPath: 'assets/images/onboarding1.gif',
                    isLastPage: false,
                  ),
                  OnBoardingPageView(
                    controller: controller,
                    title: "스캔 한 번에 모든 콘텐츠를",
                    content: "카이브만의 독점 콘텐츠를 확인해보세요",
                    imgPath: 'assets/images/onboarding2.gif',
                    isLastPage: false,
                  ),
                  OnBoardingPageView(
                    controller: controller,
                    title: "문화생활을 더 즐겁게",
                    content: "내 손 안의 문화생활 플랫폼, 카이브와 함께해요!",
                    imgPath: 'assets/images/onboarding3.gif',
                    isLastPage: true,
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: controller, // PageController
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: lightModeTheme.primaryColor,
                dotColor: lightModeTheme.disabledColor,
                radius: 4,
                dotHeight: 8,
                dotWidth: 8,
              ),
              onDotClicked: (index) {},
            ),
            const SizedBox(
              height: 52,
            ),
            isLastPage
                ? PageViewLongButton(
                    controller: controller,
                    currentPage: currentPage,
                    backgroundColor: lightModeTheme.primaryColor,
                    text: "시작하기",
                  )
                : PageViewLongButton(
                    controller: controller,
                    currentPage: currentPage,
                    backgroundColor: Colors.black,
                    text: "다음",
                  ),
          ],
        ),
      ),
    );
  }
}
