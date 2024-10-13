import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/screens/audio_screen.dart';
import 'package:xive/screens/home_screen.dart';
import 'package:xive/screens/on_boarding_screen.dart';
import 'package:xive/screens/setting_contact_screen.dart';
import 'package:xive/screens/setting_pp.dart';
import 'package:xive/screens/setting_screen.dart';
import 'package:xive/screens/setting_terms.dart';
import 'package:xive/screens/setting_withdrawal.dart';
import 'package:xive/screens/signup_screen.dart';
import 'package:xive/screens/splash_screen.dart';

part './routes.dart';

class PageItem {
  Widget page;
  String route;
  String? name;
  bool isRoot;

  PageItem({
    Key? key,
    required this.page,
    required this.route,
    this.name,
    this.isRoot = false,
  });
}

class Pages {
  static get pages => _getPages();

  static final List<PageItem> pageList = [
    PageItem(
      route: Routes.splash,
      page: const SplashScreen(),
      isRoot: true,
    ),
    PageItem(
      route: Routes.signUp,
      page: const SignupScreen(),
    ),
    PageItem(
      route: Routes.onBoarding,
      page: const OnBoardingScreen(),
    ),
    PageItem(
      route: Routes.home,
      page: const HomeScreen(),
    ),
    PageItem(
      route: Routes.setting,
      page: SettingScreen(),
    ),
    PageItem(
      route: Routes.audio,
      page: const AudioScreen(),
    ),
    PageItem(
      route: Routes.contact,
      page: const SettingContactScreen(),
    ),
    PageItem(
      route: Routes.pp,
      page: const SettingPp(),
    ),
    PageItem(
      route: Routes.terms,
      page: const SettingTerms(),
    ),
    PageItem(
      route: Routes.withdrawal,
      page: SettingWithdrawal(),
    ),
  ];

  static List<GetPage<dynamic>>? _getPages() {
    return pageList
        .map((e) => GetPage(
              name: e.route,
              page: () => e.page,
            ))
        .toList();
  }

  // static PageItem? getSettingRoutePage(RouteSettings settingsRoute) {
  //   PageItem? pageItem = pageList.firstWhereOrNull((element) {
  //     if (!element.isRoot) {
  //       if (element.route == settingsRoute.name) {
  //         return true;
  //       }
  //     }
  //     return false;
  //   });
  //   return pageItem;
  // }
}
