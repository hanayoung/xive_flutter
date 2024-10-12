
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/ticket_controller.dart';

import '../routes/pages.dart';

class SplashController extends GetxController {

  static SplashController get to {
    if (Get.isRegistered<SplashController>()) {
      return Get.find();
    }
    return Get.put(SplashController());
  }

  late BuildContext _buildContext;

  set buildContext(BuildContext context) {
    _buildContext = context;
  }

  dynamic accessToken = '';
  dynamic refreshToken = '';
  static const storage = FlutterSecureStorage();


  _asyncMethod() async {
    accessToken = await storage.read(key: 'access_token');
    refreshToken = await storage.read(key: 'refresh_token');

    await Future.delayed(const Duration(milliseconds: 1100));

  }

  @override
  void onInit() {
    _asyncMethod();

    TicketController.to.onInit();

    if (accessToken != null && refreshToken != null) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.home);
    }
    super.onInit();
  }
}