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

  var accessToken = Rxn<String>();
  var refreshToken = Rxn<String>();

  static const storage = FlutterSecureStorage();

  var isLoading = true.obs;

  Future<void> _asyncMethod() async {
    accessToken.value = await storage.read(key: 'access_token');
    refreshToken.value = await storage.read(key: 'refresh_token');

    await Future.delayed(const Duration(milliseconds: 1100));
  }

  @override
  void onInit() {
    _asyncMethod().then((_) {
      isLoading.value = false;
      if (accessToken.value != null && refreshToken.value != null) {
        TicketController.to.onInit();
        Get.offAllNamed(Routes.home);
      } else {
        Get.offAllNamed(Routes.signUp);
      }
      update();
    });

    super.onInit();
  }
}
