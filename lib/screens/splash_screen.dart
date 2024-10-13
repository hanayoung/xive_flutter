// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller) {
          if (controller.isLoading.value == true) {
            return Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(96),
                    child: Image.asset(
                      'assets/images/splash_logo.gif',
                      fit: BoxFit.contain,
                    ),
                  ),
                ));
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
