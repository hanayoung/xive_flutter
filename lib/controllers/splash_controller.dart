import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/ticket_controller.dart';

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

  Future<void> setData() async {
    accessToken.value = await storage.read(key: 'access_token');
    refreshToken.value = await storage.read(key: 'refresh_token');
    // name.value = await storage.read(key: 'name');
    // email.value = await storage.read(key: 'email');
    // loginType.value = await storage.read(key: 'login_type');
    print("setData access ${accessToken.value} refresh ${refreshToken.value}");
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void onInit() {
    setData().then((_) {
      isLoading.value = false;
      if (accessToken.value != null && refreshToken.value != null) {
        TicketController.to.onInit();
      }
    });
    super.onInit();
  }
}
