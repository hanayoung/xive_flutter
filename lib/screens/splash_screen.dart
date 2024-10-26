// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/splash_controller.dart';
import 'package:xive/routes/pages.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        autoRemove: true,
        init: SplashController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Obx(() {
                  if (controller.isLoading.value == true) {
                    return Padding(
                      padding: const EdgeInsets.all(96),
                      child: Image.asset(
                        'assets/images/splash_logo.gif',
                        fit: BoxFit.contain,
                      ),
                    );
                  } else {
                    if (controller.accessToken.value != null &&
                        controller.refreshToken.value != null) {
                      Future.microtask(() => Get.offAndToNamed(Routes.home));
                    } else {
                      Future.microtask(() => Get.offAndToNamed(Routes.signUp));
                    }
                    return const SizedBox.shrink();
                  }
                }),
              ));
        });
  }
}
