import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (context) => Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(96),
                child: Image.asset(
                  'assets/images/splash_logo.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ))
    );
  }
}
